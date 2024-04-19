#!/bin/bash

# Absolute path (filemaker-server)
    # Using absolute path instead of cd for the integrity of relative-path user input
final=$(cd "$(dirname "$0")" && pwd)
dir=$(dirname $final)

# .env: VERSION, UBUNTU, PROCESSOR
"$dir/env.sh"
source "$dir/.env"

# Major version
ver=${VERSION%%.*}

# Docker
container=fms-$ver

tag=$VERSION-u$UBUNTU-$PROCESSOR
if [ -z $REPO ]; then 
    image=$IMAGE
else
    # REPO:IMAGE-VERSION-uUBUNTU-PROCESSOR
    image=$REPO
    tag=$IMAGE-$tag
fi

# Default values
mounted_volume=$dir/data
declare -a port_mapping=(
    ["80"]="80"
    ["443"]="443"
    ["2399"]="2399"
    ["5003"]="5003"
    ["16001"]="16001"
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
                echo Use 0 to prevent the port from mapping to host
                read hostPort
                [ -z $hostPort ] && hostPort=$containerPort
                port_mapping[$containerPort]=$hostPort
            done ;;

        \? ) help ; exit 1 ;;
    esac
done
shift $((OPTIND -1))

# Port mapping flags
ports=""
for containerPort in "${!port_mapping[@]}"; do
    hostPort=${port_mapping[$containerPort]}
    [ ! "$hostPort" -eq 0 ] && ports+="-p $hostPort:$containerPort "
done

# Run the fms prep container
docker run -d --name $container --hostname $container --privileged $ports \
    -v "$mounted_volume:/opt/FileMaker/FileMaker Server/Data" \
    $image:$tag
echo FileMaker Server running in $container container
