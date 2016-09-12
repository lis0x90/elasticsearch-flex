#!/bin/bash 

set -ex

if [[ "$OSTYPE" == "darwin"* ]]; then
    st=`docker-machine status`
    if [[ ${st} != "Running"  ]]; then
        echo "[OS X] Prepare VM for Docker..."
        docker-machine start
        eval $(docker-machine env)
    fi
fi

start_node() {
  docker run -d --name=$1 --hostname=$1 $2 -e "ES_HEAP_SIZE=512m" lis0x90/elasticsearch-flex \
     /usr/share/elasticsearch/bin/elasticsearch \
       -Des.insecure.allow.root=true \
       --path.home=/usr/share/elasticsearch --path.logs=/var/log/elasticsearch --path.conf=/etc/elasticsearch \
       --network.host=_non_loopback:ipv4_ --discovery.zen.ping.multicast.enabled=true \
       --node.name=$1 --cluster.name=esaas ${@:3}
}

start_node es-master1 "-p 9201:9200" --node.master=true --node.data=false --discovery.zen.minimum_master_nodes=2 --path.data=/tmp/
start_node es-master2 "-p 9202:9200" --node.master=true --node.data=false --discovery.zen.minimum_master_nodes=2 --path.data=/tmp/
start_node es-master3 "-p 9203:9200" --node.master=true --node.data=false --discovery.zen.minimum_master_nodes=2 --path.data=/tmp/


mkdir -p /tmp/es/{1,2,3}
start_node es-data1 "-p 9211:9200 -v /tmp/es/1:/data" --node.master=false --node.data=true --path.data=/data
start_node es-data2 "-p 9212:9200 -v /tmp/es/2:/data" --node.master=false --node.data=true --path.data=/data
start_node es-data3 "-p 9213:9200 -v /tmp/es/3:/data" --node.master=false --node.data=true --path.data=/data

start_node es-client "-p 9200:9200 -p 9300:9300" --node.master=false --node.data=false
