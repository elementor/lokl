#!/bin/sh

CONTAINER_NAME=$(sudo docker ps -aqf "name=lokl")

sudo docker kill "$CONTAINER_NAME"
sudo docker container rm "$CONTAINER_NAME"

# kill container

# rm container

sudo time docker build -t lokl . --force-rm --no-cache

sudo docker run --name lokl -p 4444:4444 -d lokl
