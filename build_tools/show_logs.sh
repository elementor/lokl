#!/bin/sh

CONTAINER_NAME=$(docker ps -aqf "name=lokl")

# login to container
docker logs "$CONTAINER_NAME" 
