#!/bin/bash
# Check if .env file exists, and create it if not

# Absolute path
dir=$(dirname $(readlink -f $0))

# Exit if .env exists
[ -f "$dir/.env" ] && exit 2

# Generate .env and wait for user input
echo .env file not found, generating...
# Generate default .env
cp "$dir/defaults.env" "$dir/.env"
code "$dir/.env"
read -p "Edit the .env file, then press enter to continue, or ^C to cancel"