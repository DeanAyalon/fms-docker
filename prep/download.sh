#!/bin/bash

# Execution context - fms-docker repo
cd "$(dirname "$0")/.."

# env -> LICENSE
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

# Open URL
echo Openning $url
if [ $(uname) == "Linux" ]; then
    # On HEADLESS SSH, will open on the connecting machine, not host
        # On SSH, will require `export DISPLAY=:1`, and open on host
    xdg-open $url
elif [ $(uname) == "Darwin" ]; then
    open $url
else
    echo Please open the URL manually
fi