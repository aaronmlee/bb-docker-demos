#!/bin/bash

#client=`ifconfig | grep 'inet addr:'| grep  '172' | cut -d: -f2 | awk '{ print $1}'`

exec /usr/bin/consul agent -config-dir=/etc/consul.d -data-dir=/tmp/consul -log-level debug -join $CONSUL_LOCAL_PORT_8300_TCP_ADDR -client 0.0.0.0 --ui-dir /consul-ui
