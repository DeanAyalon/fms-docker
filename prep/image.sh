# Get absolute path
dir=$(dirname $(dirname $(readlink -f $0)))

# env -> REPO, IMAGE, VERSION, UBUNTU, PROCESSOR
source $dir/.env

# Major version
ver=${VERSION%%.*}

# Container name
container=fms-$ver-prep

# Image name and tag
if [ ! -z $REPO ]; then
    tag=$IMAGE-$VERSION-u$UBUNTU-$PROCESSOR
    image=$REPO:$tag                # ex: jackdeaniels/private:yeda-fms-19.6.4.402-u22-amd
else
    tag=$VERSION-u$UBUNTU-$PROCESSOR
    image=$IMAGE:$tag
fi

# Commit running container into 
echo Committing $container into $image
docker commit $container $image
echo Stopping $container 
docker stop $container

# Push
if [ ! -z $REPO ]; then
    read -n 1 -p "Push $tag to $REPO? [y/N]" push 
    echo ""
    if [ "$push" == "y" ] || [ "$push" == "Y" ]; then
        docker login
        docker push $image
    fi
fi
    
