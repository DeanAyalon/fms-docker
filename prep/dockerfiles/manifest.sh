#!/bin/sh

IMAGE=deanayalon/fms-prep

docker manifest create $IMAGE:u22 \
    --amend $IMAGE:u22-amd \
    --amend $IMAGE:u22-arm

docker manifest push -p $IMAGE:u22