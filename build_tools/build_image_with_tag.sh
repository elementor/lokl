#!/bin/sh

LOKL_VERSION="$1"

# TODO: check the --force-rm likely causing old containers to disappear 
docker build -f php8/Dockerfile -t lokl/lokl:"$LOKL_VERSION" . --force-rm --no-cache

