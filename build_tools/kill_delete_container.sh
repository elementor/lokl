#!/bin/sh

# solo
## CONTAINER_NAME=$(sudo docker ps -aqf "name=lokl")
## 
## # kill container
## sudo docker kill "$CONTAINER_NAME"
## # rm container
## sudo docker container rm "$CONTAINER_NAME"
## 

# kill and remove all

sudo docker kill $(sudo docker ps -q)

sudo docker rm $(sudo docker ps -a -q)
