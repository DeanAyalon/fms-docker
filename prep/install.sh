#!/bin/bash

# Mounted installation script for each version, in case Claris changes installation file naming convention
# docker exec -itu0 fms-prep /bin/bash /install/install.sh

# Execution context
cd "$(dirname "$0")/.."
source .env

docker exec -itu0 fms-prep apt install /install/fms/filemaker-server-$VERSION-${PROCESSOR}64.deb

# TODO devin (prompt)