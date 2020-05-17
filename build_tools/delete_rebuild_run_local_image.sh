#!/bin/sh

# CONTAINER_NAME=$(docker ps -aqf "name=lokl")
# 
# docker kill "$CONTAINER_NAME"
# docker container rm "$CONTAINER_NAME"

/bin/sh build_tools/kill_delete_container.sh

# kill container

# rm container

docker build -t lokl . --force-rm --no-cache

# docker run --name lokl -p 4000-5000:4000-5000 -d lokl

# docker run -e name=lokl1 -e port=4444 -p 4444:4444 -d lokl
# docker run -e name=lokl2 -e port=4445 -p 4445:4445 -d lokl

/bin/sh build_tools/run_containers.sh
