#!/bin/bash

. env.sh

$B2D stop
$B2D delete
rm -rf $DEMOROOT $DEMOLOGS
