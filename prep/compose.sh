#!/bin/bash

# Absolute path (filemaker-server)
    # Using absolute path so user-defined relative paths given to mounts stay correct
prep=$(cd "$(dirname "$0")" && pwd)
dir=$(dirname $prep)

# .env: VERSION, UBUNTU, PROCESSOR
"$dir/env.sh"           # Make sure .env exists, or generate it
source "$dir/.env"

# Major FMS version
ver=${VERSION%%.*}

# Docker
project=filemaker
container=fms-$ver-prep
image=fms
tag=prep-$ver-$PROCESSOR

# Default values
mounted_volume="$dir/data"
declare -a port_mapping=(
    ["80"]="80"
    ["443"]="443"
    ["2399"]="2399"
    ["5003"]="5003"
)

function help() {
    echo Usage: $0 [-d][-h][-m path][-p]
    echo
    echo Image and installation version are defined within the .env file:
    echo "  $dir/.env"
    echo
    echo Flags:
    echo "  -d  Stop and remove the container ($container)"
    echo "  -h  Show this Help dialog"
    echo "  -m  Define mount data path                      Default: $mounted_volume"
    echo "  -p  Interactive port forwarding override        Ports: 80, 443, 2399, 5003"
    echo "  -P  Define Docker project name                  Default: $project"
}

# Process command-line arguments
while getopts "dhmpP:" opt; do
    case ${opt} in
        # Down
        d )
            echo Taking $container down
            docker stop $container
            docker rm $container 
            exit 0 ;;

        # Help
        h ) help ; exit 2 ;;

        # Mounted data volume
        m )
            echo "Enter the path to mount the data volume:"
            read mounted_volume
            mounted_volume=$(cd $mounted_volume && pwd)
            echo $mounted_volume ;;
        
        # Ports
        p ) 
            echo Manual port mapping
            for containerPort in "${!port_mapping[@]}"; do
                echo "Container port $containerPort - Host Port: ($containerPort)"
                read hostPort
                [ -z $hostPort ] && hostPort=$containerPort
                port_mapping[$containerPort]=$hostPort
            done ;;

        P ) project=$OPTARG ;;

        \? ) help ; exit 1 ;;
    esac
done
shift $((OPTIND -1))

# # Check if processor is arm and version is 19.6.4.402
if [ "$PROCESSOR" = "arm" ] && [ "$VERSION" = "19.6.4.402" ]; then
    echo Error: FMS $VERSION does not have an arm64 version
    exit 1
fi

# Version directory
ver_dir=$VERSION-u$UBUNTU-$PROCESSOR

if [ ! -d "$prep/versions/$ver_dir" ]; then
    echo Installation directory $ver_dir not found within prep/versions
    echo Create the directory and add the proper installation files within
    echo "  $prep/versions/$ver_dir"
    exit 1
fi

# Port mapping flags
ports=""
compose_ports=""
for containerPort in "${!port_mapping[@]}"; do
    ports+="-p ${port_mapping[$containerPort]}:$containerPort "
    compose_ports+="
      - \"${port_mapping[$containerPort]}:$containerPort\""
done

# Generate docker-compose.yml
echo "name: $project
services:
  prep-$ver:
    build:
      context: $prep
      dockerfile: versions/$ver_dir/dockerfile
    image: fms:$tag
    container_name: $container
    hostname: $container
    privileged: true
    ports:$compose_ports
    volumes:
      - $prep/versions/$ver_dir:/install
      - $mounted_volume:/opt/FileMaker/FileMaker Server/Data
" > $prep/docker-compose.yml

# Remove running container
docker rm --force $container

# Run docker compose
cd $prep
docker compose up -d

# Enter prep container
echo Entering container, please run the following commands: 
echo "cd install; ./install.sh"
docker exec -it -u 0 $container /bin/sh
