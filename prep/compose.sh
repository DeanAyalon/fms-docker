#!/bin/bash

# Absolute path (filemaker-server)
prep=$(dirname $(readlink -f $0))
dir=$(dirname $prep)

# .env: VERSION, UBUNTU, PROCESSOR
$dir/env.sh
source "$dir/.env"

# Major version
ver=${VERSION%%.*}

# Docker
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
    echo Usage: $0 [-d][-m path][-p]
    echo
    echo Image and installation version are defined within the .env file:
    echo "  $dir/env"
    echo
    echo Flags:
    echo "  -d  Stop and remove the container ($container)"
    echo "  -h  Show this Help dialog"
    echo "  -m  Define mount data path                      Default: $mounted_volume"
    echo "  -p  Interactive port forwarding override        Ports: 80, 443, 2399, 5003"
}

# Process command-line arguments
while getopts "dhm:p" opt; do
    case ${opt} in
        # Down
        d )
            echo Taking $container down
            docker stop $container
            docker rm $container 
            exit 2 ;;

        # Help
        h ) help ; exit 2 ;;

        # Mounted data volume
        m )
            echo "Enter the path to mount the data volume:"
            read mounted_volume ;;
        
        # Ports
        p ) 
            echo Manual port mapping
            for containerPort in "${!port_mapping[@]}"; do
                echo "Container port $containerPort - Host Port: ($containerPort)"
                read hostPort
                [ -z $hostPort ] && hostPort=$containerPort
                port_mapping[$containerPort]=$hostPort
            done ;;

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
    exit 1
fi

# Port mapping flags
ports=""
for containerPort in "${!port_mapping[@]}"; do
    ports+="-p ${port_mapping[$containerPort]}:$containerPort "
done

# Build the prep image
docker build -t fms:prep-$ver-$PROCESSOR \
    -f $prep/versions/$ver_dir/dockerfile \
    $prep

# Run the fms prep container
docker run -d --name fms-$ver-prep --hostname fms-$ver-prep --privileged $ports \
    -v "$prep/versions/$ver_dir/install:/install" \
    -v "$dir/data:/opt/FileMaker/FileMaker Server/Data" \
    fms:prep-$ver-$PROCESSOR