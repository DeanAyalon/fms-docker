# Current State
Not yet working on arm processors (Or Yeda-Server, at least)

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