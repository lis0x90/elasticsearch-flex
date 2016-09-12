#!/bin/bash 

set -ex

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "[OS X] Prepare VM for Docker..."
    docker-machine start
    eval $(docker-machine env)
fi

start_node() {
  docker run -d --name=$1 --hostname=$1 $2 -e "ES_HEAP_SIZE=512m" lis0x90/elasticsearch-flex \
     /usr/share/elasticsearch/bin/elasticsearch \
       -Des.insecure.allow.root=true \
       --path.home=/usr/share/elasticsearch --path.logs=/var/log/elasticsearch --path.conf=/etc/elasticsearch \
       --network.host=_non_loopback:ipv4_ --discovery.zen.ping.multicast.enabled=true \
       --node.name=$1 --cluster.name=esaas ${@:3}
}

start_node esmaster1 "-p 9201:9200" --node.master=true --node.data=false --discovery.zen.minimum_master_nodes=2 --path.data=/tmp/
start_node esmaster2 "-p 9202:9200" --node.master=true --node.data=false --discovery.zen.minimum_master_nodes=2 --path.data=/tmp/
start_node esmaster3 "-p 9203:9200" --node.master=true --node.data=false --discovery.zen.minimum_master_nodes=2 --path.data=/tmp/


mkdir -p /tmp/es/{1,2,3}
start_node esdata1 "-p 9211:9200 -v /tmp/es/1:/data" --node.master=false --node.data=true --path.data=/data
start_node esdata2 "-p 9212:9200 -v /tmp/es/2:/data" --node.master=false --node.data=true --path.data=/data
start_node esdata3 "-p 9213:9200 -v /tmp/es/3:/data" --node.master=false --node.data=true --path.data=/data

start_node esclient "-p 9200:9200 -p 9300:9300" --node.master=false --node.data=false
