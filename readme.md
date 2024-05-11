# What is this?
This repository is made to create Docker containers running FileMaker Server, after failing with the scripts supplied by Claris.

## Current State
Not yet working on arm processors (Or Yeda-Server, at least)

## Submodule Access
This repository has a git submodule set to the claris-script directory. The submodule is a private repository and the script may only be accessed internally by me.<br>
To get the Docker FMS installation script as it is provided by Claris, install FileMaker Server on a machine, and you'll find the script in the following path: `/opt/FileMaker/FileMaker Server/Tools/Docker`.

# Use
## Downloads
https://accounts.claris.com/software/license/FMS_LICENSE_CODE <br>
Or use [the download script](.versions/download.sh) - Based on [.env](../.env)

## Pre-Installation
Place the FileMaker Server installation .deb file within the appropriate [version](./prep/versions/) folder

## Installation
prep
- compose.sh
- (Within the prep container) install.sh
  > This may in the future be integrated as an entrypoint in dockerfile
- image.sh

final
- compose.sh

## Certificates
> TODO: Check about automatic installation

- Login to the [Admin Console](https://localhost/admin-console) and import the certificate files
- Restart FileMaker Server

## Restart FileMaker Server
Not to be confused with the "Restart Database Server" within the Admin Console

Within the fms container
```sh
sudo systemctl stop filemaker 
sudo systemctl start filemaker 
```

# Errors
### Failed to fetch URL    Temporary failute resolving 'DOMAIN'
```sh
echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" |tee -a /etc/resolv.conf
```