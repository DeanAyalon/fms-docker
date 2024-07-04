# Purpose
This repository is made to create Docker containers running FileMaker Server, and optionally Devin.fm.<br>
While this project was made for my own use, it is public and available for others, and I will be maintaining it - So if you experience any problems [this document](./docs/errors.md) is not able to solve, simply [open an issue](https://github.com/DeanAyalon/fms-docker/issues/new) or [contact me](mailto:dev@deanayalon.com)

## What about the official script?
The official Claris FMS-Docker script only supports Ubuntu 20.04 and 22.04.<br>
My repository should work for any UNIX based OS, with these having been tested:
- Manjaro (Arch) v24.0.3 Wynsdey
- MacOS Ventura 13.6.7 (Intel i7 and M1 chips)

## Supported FMS versions
This repository supports FileMaker Server versions 19 through 21.<br>
The available versions are 19.6.4.402, 20.3.2.205 and 21.0.1.51, versions different than those will require manual dockerfile creation. This should be a simple process, usually just updating packages.

> May be changed in the future, currently v20 and v21 use the same dockerfiles (So, dockerfile.u20 and dockerfile.u22)
> > Test using `ubuntu` instead of `amd64/ubuntu` and `arm64v8/ubuntu`

## Submodule Access
This repository has a few git submodules set to private repositories. **They are not required for execution of this repository!** 

### claris-fms-docker
The official Claris Docker script directory. The submodule is here for my testing purposes only<br>
To get the Docker FMS installation script as it is provided by Claris, you must have access to a FileMaker Server installation.

#### FileMaker Server 2023 (v20)
Install FileMaker Server 20 on a machine, and you'll find the script in the following path: `/opt/FileMaker/FileMaker Server/Tools/Docker`.

#### FileMaker Server 2024 (v21)
The script will be available in the `Docker` directory within the FMS-21 installation package

### install_devin
A fork of the official [Devin.fm](https://devin.fm) installation script for UNIX ([download](https://download.devin.fm/downloads/server/latest/install_devin_unix.zip)).<br>
Proposed a modification and sent it to the developers, so that the script works regardless of execution context.

# Use
## Downloads
First, download the FileMaker Server installation files.<br>
https://accounts.claris.com/software/license/FMS_LICENSE_CODE <br>
Or use the [download script](.versions/download.sh) - Based on [.env](.env) `LICENSE` variable

For Devin.fm, also download the [installation script](https://download.devin.fm/downloads/server/latest/instlal_devin_unix.zip), and place it within [its installation directory](./prep/installations/devin/)

## Pre-Installation
Place the FileMaker Server installation `.deb` file within the appropriate [version](./prep/versions/) folder.<br>
If the version folder does not exist, it can be duplicated from one of the other version folders - But dockerfile may need to be modified to update dependencies.

## Installation (prep)
- Compose: `docker compose up -d prep`
- [install script](./prep/install.sh) - Executes the filemaker server installation within the container
  > If installing Devin.fm, make sure to choose an admin-console password that does NOT contain ':'
    - Afterwards, user will be prompted and instructed on how to install Devin.fm
- [image script](./prep/image.sh) (docker commit)

**Do NOT upload the final image publicly, as it includes your admin-console credentials!**<br>
It may also include your Devin API key for staging/production servers using Devin.fm

## Post-Installation
### Backup
The FileMaker Server backup directories (ClonesOnly, Backups) and the external files (RC_Data_FMS) use bind mounts, so that they are not saved within the Docker volume assigned for FMS.

In order to back the FMS or Devin.fm server itself up, use the backup service: `docker compose up backup`
This container will archive the volumes assigned to fms and devin into the `$DEV_BACKUP_MOUNT/<timestamp>/<volume>.tar.gz`

This method may allow one to work with a 'portable' FMS server, and thus, use Devin.fm locally

#### Restore 
The restore service is used to decompress backups into their respective containers. To use it: `docker compose up restore`

This service is not yet ideal and works with a few restrictions:
- Restores the most recently modified directory within the dev-backups mount.
- Restores the backups by title, and matches them with `$DEVIN_VOL` and `$FMS_VOL`

> Make sure the archive names in the latest directory within the dev-backups mount match the volumes set in `.env`, or the restore service will simply not find the correct file to unarchive.

> I do not know yet how this service behaves with already populated volumes, so currently, it only certainly works with empty volumes.<br>
> I will test this out, and may add lines emptying the volumes before restoring the backups


### Bind Mounts
The default mounts used are found within the [mounts directory](./mounts/), to use a different path, change the `$*_MOUNT` variables in [.env](./.env).<br>
> Make sure the mounted directory has RWX permissions for both the user and group!

**Mounted directories:**
- [backups](./mounts/backups/) holds the `.fmp12` files made by FileMaker Server full backups
- [clones](./mounts/clones/) holds the `.fmp12` files made by FileMaker Server cloning
- [dev-backup](./mounts/dev-backup/) holds the `.tar.gz` archives of the `$FMS_VOL` and `$DEVIN_VOL` volumes, made by the backup service
- [files](./mounts/files) holds the external files stored by FileMaker container fields

### Certificates
- Login to the [Admin Console](https://localhost/admin-console) and import the certificate files
- Restart FileMaker Server, or the container

### Use Existing Databases
Use the [copy-db script](./scripts/copy-db.sh) to copy a database into the fms container. And subsequently, into the `$FMS_VOL` volume defined in `.env`.<br>
This will handle the necessary permissions, and copy the db into the Databases folder

> Will in the future support the Secure folder, and custom directories

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

> If not working, composing the container down and up again may help.

# ⚠️ Errors ⚠️
See [Errors](./docs/errors.md)

# Featured Technologies 
![FileMaker](https://img.shields.io/badge/claris-filemaker-black.svg?style=for-the-badge&logo=claris&logoColor=white)
[![FileMaker Server](https://img.shields.io/badge/claris-FileMaker_Server-black.svg?style=for-the-badge&logo=claris&logoColor=white)](https://www.credly.com/earner/earned/badge/bbdd64a9-b1e0-48ac-9ab0-bbfb4d737204) 
[![Devin.fm](https://custom-icon-badges.demolab.com/badge/devin.fm-120e6d.svg?style=for-the-badge&logo=devin.fm)](https://devin.fm)

[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://github.com/DeanAyalon/verdaccio/pkgs/container/verdaccio)

[![VSCode](https://img.shields.io/badge/vscode-white.svg?style=for-the-badge&logo=visual-studio-code&logoColor=007ACC)](https://github.com/DeanAyalon)
![Shell](https://img.shields.io/badge/shell-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)