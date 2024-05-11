#!/bin/bash
# Checks if .env file exists and is up to date; Generates it otherwise

# Execution context - this repo
cd "$(dirname "$0")"

# Current version, based on defaults.env
version=$(awk -F '=' '/^ENV_VER/ {print $2}' defaults.env)

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
echo Generating default .env file
# Generate default .env
cp defaults.env .env
code .env
[ $old ] && code old.env
echo Edit the .env file, then try again...
exit 1