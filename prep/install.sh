#!/bin/bash

# Mounted installation script for each version, in case Claris changes installation file naming convention
docker exec -itu0 fms-prep /bin/bash /install/install.sh

Execution context
cd "$(dirname "$0")/.."
source .env

cmd="docker exec -itu0 fms-prep"
$cmd apt install /install/fms/filemaker-server-$VERSION-${PROCESSOR}64.deb || exit 1

# TODO devin (prompt for confirmation)

# Prompt the user to confirm if they want to install Devin.fm
if [ -f ./prep/installations/devin/install_devin_unix.zip ]; then
    echo "Do you want to install Devin.fm? (y/N)"
    read install_devin

    if [ "$install_devin" = "Y" ] || [ "$install_devin" = "y" ]; then
        echo Installing Devin.fm...
        $cmd unzip /install/devin/install_devin_unix.zip -d /tmp
        echo Execute the following commands: 
        echo "  cd /tmp/install_devin"
        echo "  ./install_devin_unix.sh"
        $cmd /bin/bash
        # For some reason, installing Devin from outside the container does not seem to work
            # Try $cmd cd /tmp/install_devin; ./install_devin.unix.sh
        # $cmd /tmp/install_devin/install_devin_unix.sh
    fi
fi