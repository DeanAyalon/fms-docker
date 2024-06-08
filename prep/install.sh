#!/bin/bash

# Constants
container=fms-prep

# Execute command within the container
cmd() {
    echo docker exec -itu0 $FMS_PREP_CONTEXT $@
}

# Mounted installation script for each version, in case Claris changes installation file naming convention
docker exec -itu0 fms-prep /bin/bash /install/install.sh

# Execution context
cd "$(dirname "$0")/.."
source .env

# Container context
export FMS_PREP_CONTEXT=$container

# Install FileMaker Server
cmd apt install /install/fms/filemaker-server-$VERSION-${PROCESSOR}64.deb || exit 1

# Prompt the user to confirm if they want to install Devin.fm
if [ -f ./prep/installations/devin/install_devin_unix.zip ]; then
    echo "Do you want to install Devin.fm? (y/N)"
    read install_devin

    if [ "$install_devin" = "Y" ] || [ "$install_devin" = "y" ]; then
        echo Installing Devin.fm...
        cmd unzip /install/devin/install_devin_unix.zip -d /tmp
        echo Execute the following commands: 

        # Temporary solution until Devin.fm implements my enhancement
        export FMS_PREP_CONTEXT="-w /tmp/install_devin $container"
        cmd ./install_devin_unix.sh

        # cmd /tmp/install_devin/install_devin_unix.sh
    fi
fi