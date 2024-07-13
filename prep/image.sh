#!/bin/bash

# Constants
container=fms-prep
[ ! -z "$1" ] && container=$1

cmd() {
    docker exec -itu0 "$container" $@
}

clean() {
    echo Cleaning up prep container

    rm_cmd() {
        cmd rm -rf "$1" > /dev/null
    }

    # Cleanup cache
    rm_cmd /var/lib/apt/lists
    rm_cmd /var/cache
    rm_cmd /var/tmp
    rm_cmd /tmp

    echo Remove sample FileMaker database?
    read no_sample
    if [ "$no_sample" = "y" ] || [ "$no_sample" = "Y" ]; then
        docker exec -itu0 -w "/opt/FileMaker/FileMaker Server/Data/Databases" "$container" rm -rf Sample > /dev/null
    fi
}

# SCRIPT EXECUTION

# Execution context - fms-docker repo
cd "$(dirname "$0")/.."

# env -> REPO, IMAGE, VERSION, UBUNTU, PROCESSOR
[ ! -f .env ] && exit 1
source .env

# Image tag
[ -z $PROCESSOR ] && PROCESSOR=amd
tag=$VERSION-u$UBUNTU-$PROCESSOR
[ ! -z $TAG_PREFIX ] && tag=$TAG_PREFIX-$tag
[ ! -z $TAG_SUFFIX ] && tag+=-$TAG_SUFFIX

# Clean container
clean

# Commit running container into image
echo Committing $container into $IMAGE:$tag
docker commit "$container" $IMAGE:$tag
echo Stopping $container 
docker stop "$container"

# Warn
echo
echo WARNING!
echo The image $IMAGE:$tag contains secure information
echo Do NOT upload the image to a public registry!