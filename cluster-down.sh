#!/bin/bash 

docker kill $(docker ps -aq --filter "name=es_*")
docker rm $(docker ps -aq --filter "name=es_*")
rm -rf /tmp/es/{1,2,3}
