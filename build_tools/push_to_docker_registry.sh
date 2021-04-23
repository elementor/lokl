#!/bin/sh

LOKL_RELEASE_VERSION="5.0.0-rc2zzzz"

# PHP 8
docker push "lokl/lokl:php8-$LOKL_RELEASE_VERSION"

# PHP 7
docker push "lokl/lokl:php7-$LOKL_RELEASE_VERSION"
