#!/bin/bash

# Execution context - fms-docker repo
cd "$(dirname "$0")/../.."

# env -> LICENSE
./env.sh
source .env

# Open downlosd link
baseUrl=https://accounts.claris.com/software/license
url=$baseUrl/$LICENSE

# License must be defined
if [ -z $LICENSE ]; then
    echo LICENSE env variable not defined, cannot generate download link
    echo You may manually open the URL:
    echo $baseUrl/YOUR-LICENSE-HERE
    exit 1
fi


if [ $(uname) == "Linux" ]; then
    xdg-open $baseUrl/$LICENSE
    # On SSH, will open on the connecting machine, not host
elif [ $(uname) == "Darwin" ]; then
    open $baseUrl/$LICENSE
else
    echo Open $baseUrl
fi
