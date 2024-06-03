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
Or use the [download script](.versions/download.sh) - Based on [.env](.env)

## Pre-Installation
Place the FileMaker Server installation .deb file within the appropriate [version](./prep/versions/) folder.<br>
If the version folder does not exist, it can be duplicated from one of the other version folders - But dockerfile may need to be modified to update dependencies.

## Installation (prep)
- Compose: `docker compose up -d prep`
- [install script](./prep/install.sh) - Executes the filemaker server installation within the container
    - Afterwards, user will be prompted and instructed on how to install Devin.fm
- [image script](./prep/image.sh) (docker commit)
> Since the final image is created via docker commit, the /install volume will be defined in the image, and always mounted

## Post-Installation
### Certificates
- Login to the [Admin Console](https://localhost/admin-console) and import the certificate files
- Restart FileMaker Server, or the container

### Use Existing Databases
Use the [copy-db script](./scripts/copy-db.sh) to copy a database into the fms container. And subsequently, into the `$FMS_VOL` volume defined in `.env`.<br>
This will handle the necessary permissions, and copy the db into the Databases folder

## Compose Files
### [compose.yml](./compose.yml)
The base compose file, defines prep and fms

### [compose.proxy.yml](./compose.proxy.yml)
Defines environment variables for [nginx-proxy](https://github.com/nginx-proxy/nginx-proxy), according to `.env`

### [compose.standalone.yml](./compose.standalone.yml)
When not using proxy, this compose file maps port 443 to host

## Restart FileMaker Server
Not to be confused with the "Restart Database Server" within the Admin Console

Within the fms container
```sh
systemctl stop fmshelper
systemctl start fmshelper
```
> The service may be named `filemaker` in some cases.<br>
TODO check

# Errors
See [Errors](./docs/errors.md)

# Featured Technologies 
![FileMaker](https://img.shields.io/badge/claris-filemaker-black.svg?style=for-the-badge&logo=claris&logoColor=white)
[![FileMaker Server](https://img.shields.io/badge/claris-FileMaker_Server-black.svg?style=for-the-badge&logo=claris&logoColor=white)](https://www.credly.com/earner/earned/badge/bbdd64a9-b1e0-48ac-9ab0-bbfb4d737204) 

[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://github.com/DeanAyalon/verdaccio/pkgs/container/verdaccio)

[![VSCode](https://img.shields.io/badge/vscode-white.svg?style=for-the-badge&logo=visual-studio-code&logoColor=007ACC)](https://github.com/DeanAyalon)
![Shell](https://img.shields.io/badge/shell-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)