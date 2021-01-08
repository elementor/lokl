#!/bin/sh

docker build -f php8/Dockerfile -t lokl/lokl:php8base . --force-rm --no-cache
docker rm --force php8base
docker run -e N="php8base" -e P="3465" --name="php8base" -p "3465":"3465" -d lokl/lokl:"php8base"

attempt_counter=0
max_attempts="10"
site_poll_sleep_duration="3"

until docker logs -n 10 php8base 2>&1 | grep 'processes'; do

    if [ ${attempt_counter} -eq "${max_attempts}" ]; then
      echo "Timed out waiting for provisioning to complete..."
      exit 1
    fi

    printf '.'
    attempt_counter=$((attempt_counter+1))
    sleep "$site_poll_sleep_duration"
done

docker commit php8base lokl/lokl:php8
