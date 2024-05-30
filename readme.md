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
Or use [the download script](.versions/download.sh) - Based on [.env](.env)

## Pre-Installation
Place the FileMaker Server installation .deb file within the appropriate [version](./prep/versions/) folder.<br>
If the version folder does not exist, it can be duplicated from one of the other version folders - But dockerfile may need to be modified to update dependencies.

## Installation (prep)
- Compose: `docker compose up -d prep`
- [install script](./prep/install.sh) - Executes the filemaker server installation within the container
- (Optional) Add SSL certificate - Can also be done after running the finalized image
- [image script](./prep/image.sh) (docker commit)
> Since the final image is created via docker commit, the /install volume will be defined in the image, and always mounted

## Certificates
> TODO: Check about automatic installation with .env LICENSE

- Login to the [Admin Console](https://localhost/admin-console) and import the certificate files
- Restart FileMaker Server

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
## During Installation
### Failed to fetch URL    Temporary failute resolving 'DOMAIN'
```sh
echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" |tee -a /etc/resolv.conf
```

### Permission error while Cleaning up 
After configuring installation and credentials, the process may crash with something like this:
```
dpkg: error processing archive /tmp/apt-dpkg-install-M35WM6/092-filemaker-server-20.3.2.205-arm64.deb (--unpack):
 error creating directory './opt/FileMaker/FileMaker Server/Data/Caches': Permission denied
dpkg: error while cleaning up:
 unable to remove newly-extracted version of '/opt/FileMaker/FileMaker Server/Data/Caches': Permission denied
dpkg-deb: error: paste subprocess was killed by signal (Broken pipe)

E: Sub-process /usr/bin/dpkg returned an error code (1)
```

That indicates a permission error, and seems to occur when bind-mounting the data folder on arm64 machines (or at least on Yeda-Server).<br>
Removing the `MOUNT` variable from .env seems to solve the problem.
> Check if there's any permission level that would allow using a bind mount

# Featured Technologies 
![FileMaker](https://img.shields.io/badge/claris-filemaker-black.svg?style=for-the-badge&logo=claris&logoColor=white)
[![FileMaker Server](https://img.shields.io/badge/claris-FileMaker_Server-black.svg?style=for-the-badge&logo=claris&logoColor=white)](https://www.credly.com/earner/earned/badge/bbdd64a9-b1e0-48ac-9ab0-bbfb4d737204) 

[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://github.com/DeanAyalon/verdaccio/pkgs/container/verdaccio)

[![VSCode](https://img.shields.io/badge/vscode-white.svg?style=for-the-badge&logo=visual-studio-code&logoColor=007ACC)](https://github.com/DeanAyalon)
![Shell](https://img.shields.io/badge/shell-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)