#!/bin/bash
# Check if .env file exists, and create it if not

# Execution context - fms-docker repo
cd "$(dirname "$0")"

# Exit if .env exists
[ -f .env ] && exit 2

# Generate .env and wait for user input
echo .env file not found, generating...
# Generate default .env
cp "defaults.env" ".env"
code ".env"
read -p "Edit the .env file, then press enter to continue, or ^C to cancel"