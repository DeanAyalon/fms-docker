#!/bin/bash

# Execution context - fms-docker repo
cd "$(dirname "$0")/.."

# env -> REPO, IMAGE, VERSION, UBUNTU, PROCESSOR
[ ! -f .env ] && exit 1
source .env

# Container name
container=fms-prep

# Image tag
[ -z $PROCESSOR ] && PROCESSOR=amd
tag=$VERSION-u$UBUNTU-$PROCESSOR
[ ! -z $TAG_PREFIX ] && tag=$TAG_PREFIX-$tag
[ ! -z $TAG_SUFFIX ] && tag+=-$TAG_SUFFIX

# Commit running container into image
echo Committing $container into $IMAGE:$tag
docker commit $container $IMAGE:$tag
echo Stopping $container 
docker stop $container

# Push
if [ ! -z $REPO ]; then
    read -n 1 -p "Push $IMAGE:$tag? [y/N]" push 
    echo ""
    if [ "$push" == "y" ] || [ "$push" == "Y" ]; then
        docker login
        docker push $IMAGE:$tag
    fi
fi