#!/bin/sh

LOKL_RELEASE_VERSION="5.0.0-rc1"

docker build -f php7/Dockerfile -t lokl/lokl:php7base . --force-rm --no-cache
docker rm --force php7base
docker run -e N="php7base" -e P="3466" --name="php7base" -p "3466":"3466" -d lokl/lokl:"php7base"

attempt_counter=0
max_attempts="30"
site_poll_sleep_duration="3"

until docker logs php7base 2>&1 | grep 'processes'; do

    if [ ${attempt_counter} -eq "${max_attempts}" ]; then
      echo "Timed out waiting for provisioning to complete..."
      exit 1
    fi

    printf '.'
    attempt_counter=$((attempt_counter+1))
    sleep "$site_poll_sleep_duration"
done

docker commit php7base "lokl/lokl:php7-$LOKL_RELEASE_VERSION"
