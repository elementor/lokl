#!/bin/sh

CONTAINER_NAME=$(sudo docker ps -aqf "name=lokl")

# kill container
sudo docker kill "$CONTAINER_NAME"
# rm container
sudo docker container rm "$CONTAINER_NAME"

# build image
sudo time docker build -t lokl . --force-rm --no-cache

$ run container
sudo docker run --name lokl -p 4444:4444 -d lokl
