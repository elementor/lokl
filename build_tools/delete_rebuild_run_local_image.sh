#!/bin/sh

# CONTAINER_NAME=$(sudo docker ps -aqf "name=lokl")
# 
# sudo docker kill "$CONTAINER_NAME"
# sudo docker container rm "$CONTAINER_NAME"

/bin/sh build_tools/kill_delete_container.sh

# kill container

# rm container

sudo docker build -t lokl . --force-rm --no-cache

# sudo docker run --name lokl -p 4000-5000:4000-5000 -d lokl

# sudo docker run -e name=lokl1 -e port=4444 -p 4444:4444 -d lokl
# sudo docker run -e name=lokl2 -e port=4445 -p 4445:4445 -d lokl

/bin/sh build_tools/run_containers.sh
