#!/bin/sh

# solo
## CONTAINER_NAME=$(docker ps -aqf "name=lokl")
## 
## # kill container
## docker kill "$CONTAINER_NAME"
## # rm container
## docker container rm "$CONTAINER_NAME"
## 

# kill and remove all

docker kill "$(docker ps -q)"

docker rm "$(docker ps -a -q)"
