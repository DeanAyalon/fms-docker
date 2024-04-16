# Get absolute path
dir=$(dirname $(dirname $(readlink -f $0)))

# env -> VERSION
source $dir/.env

# Commit running container into 
docker commit fms-prep $IMAGE-$VERSION
docker stop fms-prep