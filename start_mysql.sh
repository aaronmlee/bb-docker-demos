#!/bin/bash

. env.sh

set -x -e

# Build containers
#cd $JOIN; docker build -t $JOIN .; cd -
cd $MYSQL; docker build -t $MYSQL .; cd -
#cd $MONITOR; docker build -t $MONITOR .; cd -

# Start containers, beginning with "join" agent (consul running in -server -bootstrap mode)
#echo "Starting join agent"
# Note this has the special name "consul-agent-local-join" - it is proposed that on any docker host, at least one container with this name be running. 
# That container will have some good way of joining a gossip pool off the host, whether that be by forming one (-bootstrap), or using some global configuration
# mechanism that is *not* consul, like static DNS... maybe it makes sense for one to load-balance connections to docker agents internally (i.e. using an ELB)
# on a known per-datacenter addres, even locally. 
# Anyway, that container should be linked to the other containers 
#nohup docker run -i --rm --name consul-agent-local-join -v $DEMOLOGS/$JOIN:/var/log $JOIN 
# let join agent start up
#sleep 10
# mysql

  echo "starting mysql"
docker run -i --rm -name $MYSQL -v $DEMOLOGS/$MYSQL:/var/log -link consul-agent-local-join:CONSUL_LOCAL $MYSQL
#sleep 10
# monitor, expose consul ports on docker host
#echo "starting monitoring container"
#nohup docker run -i --rm --name $MONITOR -v $DEMOLOGS/$MONITOR:/var/log -link consul-agent-local-join:CONSUL_LOCAL -p 8300:8300 -p 8301:8301 -p 8302:8302 -p 8400:8400 -p 8500:8500 -p 8600:8600 $MONITOR &
