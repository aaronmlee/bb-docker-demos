#!/bin/bash

. env.sh

# Set up demo area
if [ -e $DEMOROOT ]; then
    echo "DEMOROOT $DEMOROOT exists, exiting without changing anything"
    exit 1
fi

mkdir -p $DEMOROOT
cd $DEMOROOT
git clone https://github.com/blackbirdit/boot2docker
chmod 755 $B2D

$B2D init
$B2D up
# Make /var/log paths on docker host that will be bound to each container (-v /path:/var/log), and install consul on docker host
$B2D ssh sudo -u root bash -c "'mkdir -p $DEMOLOGS/{$JOIN,$MYSQL,$MONITOR}/supervisor; mkdir -p $DEMOLOGS/$MYSQL/mysql; chmod -R 777 $DEMOLOGS; curl -s -L -O https://dl.bintray.com/mitchellh/consul/0.2.0_linux_386.zip; unzip 0.2.0_linux_386.zip; cp consul /usr/bin; chmod 755 /usr/bin/consul'"
mkdir -p $DEMOLOGS > /dev/null 2>&1

