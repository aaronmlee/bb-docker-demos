#!/bin/bash

. env.sh

docker kill consul-agent-local-join 
docker kill consul-monitor 
docker kill tutum-docker-mysql
