#!/bin/bash 

docker kill $(docker ps -aq --filter "name=es*")
docker rm $(docker ps -aq --filter "name=es*")
rm -rf /tmp/es/{1,2,3}
