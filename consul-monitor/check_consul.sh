#!/bin/sh

set -e 

while true; do
    echo ">>>>>>>>>>>"
    consul members
    echo ""
    echo ">>>>>>>>>>>"
    curl -v http://localhost:8500/v1/agent/members
    echo ""
    echo ">>>>>>>>>>>"
    curl -v http://localhost:8500/v1/agent/services
    echo ""
    sleep 5
done

