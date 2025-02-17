#!/bin/sh
solution=$1
cd "$(dirname "$0")"
mkdir -p mnt
docker cp "fms:/opt/FileMaker/FileMaker Server/Data/Databases/$solution.fmp12" "./mnt/$solution.fmp12"