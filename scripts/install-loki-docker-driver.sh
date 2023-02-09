#!/bin/bash

docker plugin ls | grep loki >/dev/null
uninstalled=$?
if [ $uninstalled != 0 ]; then
    echo "Installing Loki Docker Driver..."
    docker plugin install grafana/loki-docker-driver:latest \
        --alias loki --grant-all-permissions
fi
