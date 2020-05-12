#!/bin/sh

CONTAINER_NAME=$(sudo docker ps -aqf "name=lokl")

# login to container
sudo docker exec -it "$CONTAINER_NAME" /bin/sh
