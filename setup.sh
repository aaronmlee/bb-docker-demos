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
$B2D ssh sudo -u root bash -c "'mkdir -p /tmp/varlog/supervisor; mkdir -p /tmp/varlog/mysql; mkdir -p /tmp/varlogchk/supervisor; chmod -R 777 /tmp/'"

