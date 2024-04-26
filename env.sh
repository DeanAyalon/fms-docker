#!/bin/bash
# Checks if .env file exists and is up to date; Generates it otherwise

# Current version, based on defaults.env
version=$(grep -oP '^ENV_VER=\K.*' defaults.env)

# Execution context - fms-docker repo
cd "$(dirname "$0")"

# Exit if .env exists
if [ -f .env ]; then
    source .env
    if [ -z $ENV_VER ] || [ $ENV_VER != $version ]; then 
        echo "Old .env file found ( $ENV_VER / $version )"
        echo "Renaming .env -> old.env"
        mv .env old.env
        old=true
    else 
        # .env up to date
        exit 2
    fi
fi

# Generate .env and wait for user input
echo generating .env file...
# Generate default .env
cp defaults.env .env
code .env
[ $old ] && code old.env
read -p "Edit the .env file, then press enter to continue, or ^C to cancel"