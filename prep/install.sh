#!/bin/bash

# Constants
container=fms-prep
[ ! -z "$1" ] && container=$1

# Execute command within the container
cmd() {
    docker exec -itu0 $FMS_PREP_CONTEXT $@
}
export FMS_PREP_CONTEXT=$container

# Update OS
echo Updating libraries
cmd apt-get update

# Execution context
cd "$(dirname "$0")/.."
source .env
[ -z $PROCESSOR ] && PROCESSOR=amd

# Install FileMaker Server
cmd apt install /install/fms/filemaker-server-$VERSION-${PROCESSOR}64.deb || exit 1

# Prompt the user to confirm if they want to install Devin.fm
if [ -f ./prep/installations/devin/install_devin_unix.zip ]; then
    echo "Do you want to install Devin.fm? (y/N)"
    read install_devin

    if [ "$install_devin" = "Y" ] || [ "$install_devin" = "y" ]; then
        echo Installing Devin.fm...
        cmd unzip /install/devin/install_devin_unix.zip -d /tmp

        # Temporary solution until Devin.fm implements my enhancement
        export FMS_PREP_CONTEXT="-w /tmp/install_devin $container"
        cmd ./install_devin_unix.sh

        # cmd /tmp/install_devin/install_devin_unix.sh
    fi
fi

# If /install/others has files beside readme.md, prompt installation