#!/bin/sh
#
# System health checker, to run on schedule and check:
#
#    - hosts file has our subdomain entry
#

LOKL_DOMAIN="$N.localhost"

# check every 2 seconds that we have our subdomain DNS entry
while true; do
  if ! grep -q "$LOKL_DOMAIN" /etc/hosts; then
          echo "127.0.0.1         $LOKL_DOMAIN" >> /etc/hosts
      echo
  fi

  sleep 2
done
