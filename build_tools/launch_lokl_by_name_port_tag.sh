#!/bin/sh

LOKL_NAME="$1"
LOKL_PORT="$2"
LOKL_VERSION="$3"

docker run -e N="$LOKL_NAME" -e P="$LOKL_PORT" \
  --name="$LOKL_NAME" -p "$LOKL_PORT":"$LOKL_PORT" -d lokl/lokl:"$LOKL_VERSION"
