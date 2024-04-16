#!/bin/bash

installations=$(dirname $(readlink -f $0))
dir=$(readlink -f $installations/../../..)
echo $dir

source $dir/.env
baseUrl=https://accounts.claris.com/software/license/

# Use xdg-open to open the URL in the default web browser
xdg-open $baseUrl$LICENSE