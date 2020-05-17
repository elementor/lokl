#!/bin/sh

CONTAINER_NAME=$(docker ps -aqf "name=lokl")

# login to container
docker exec -it "$CONTAINER_NAME" /bin/sh
