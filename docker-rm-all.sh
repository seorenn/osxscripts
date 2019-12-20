#!/bin/sh

RUNNINGS=$(docker ps -q)
if [ -n "$RUNNINGS" ]; then
    echo "Killing running containers..."
    docker kill "$RUNNINGS"
fi

CONTAINERS=$(docker ps -a -q)
if [ -n "$CONTAINERS" ]; then
    echo "Removing all containers..."
    docker rm "$CONTAINERS"
fi
