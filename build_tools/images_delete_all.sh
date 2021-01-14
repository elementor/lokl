#!/bin/sh

docker rmi -f "$(docker images -a -q)"

