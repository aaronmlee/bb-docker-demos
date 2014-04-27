#!/bin/bash

exec /usr/bin/consul agent -config-dir=/etc/consul.d -data-dir=/tmp/consul -log-level debug -join $CONSUL_LOCAL_PORT_8300_TCP_ADDR
