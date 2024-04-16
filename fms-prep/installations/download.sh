#!/bin/bash

# Absolute paath
installations=$(dirname $(readlink -f $0))
dir=$(readlink -f $installations/../..)
echo $dir

# env -> LICENSE
source $dir/.env

baseUrl=https://accounts.claris.com/software/license
xdg-open $baseUrl/$LICENSE
# On SSH, will open on the connecting machine 