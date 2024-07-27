#!/bin/bash

# Execution context - fms-docker repo
cd "$(dirname "$0")/.."

# env -> REPO, IMAGE, VERSION, UBUNTU, PROCESSOR
[ ! -f .env ] && exit 1
source .env

# Container name
container=fms-prep
[ ! -z "$1" ] && container=$1

# Image tag
[ -z $IMAGE ] && IMAGE=fms
[ -z $PROCESSOR ] && PROCESSOR=amd
tag=$VERSION-u$UBUNTU-$PROCESSOR
[ ! -z $TAG_PREFIX ] && tag=$TAG_PREFIX-$tag
[ ! -z $TAG_SUFFIX ] && tag+=-$TAG_SUFFIX

# Clean up
db_path="/opt/FileMaker/FileMaker Server/Data/Databases"
sample_db_exists=$(docker exec $container ls "$db_path" | grep Sample)
if [ ! -z $sample_db_exists ]; then
    echo Remove sample FileMaker database? [Y/n]
    read remove_sample
    if [ "$remove_sample" != "n" ] && [ "$remove_sample" != "N" ]; then
        docker exec -w "$db_path" $container rm -rf Sample
    fi
fi

# Commit running container into image
echo Committing $container into $IMAGE:$tag
docker commit $container $IMAGE:$tag
echo Removing $container 
docker rm -f $container

# Push
if [ ! -z $REPO ]; then
    read -n 1 -p "Push $IMAGE:$tag? [y/N]" push 
    echo ""
    if [ "$push" == "y" ] || [ "$push" == "Y" ]; then
        docker login
        docker push $IMAGE:$tag
    fi
fi