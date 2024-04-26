# Use
Put here the unzipped Linux installation files

Working versions tested:
- fms_19.6.4.402_Ubuntu20 (filemaker-server-19.6.4.402-amd64.deb)

## Downloads
https://accounts.claris.com/software/license/FMS_LICENSE_CODE <br>
Or use [the download script](.versions/download.sh) - Based on [.env](../.env)

## Steps
Prep
- compose.sh
- (Within the prep container) install.sh
- image.sh

final
- compose.sh

## Certificates
> TODO: Check about automatic installation

- Login to the [Admin Console](https://localhost/admin-console) and import the certificate files
- Restart FileMaker Server

## Restart FileMaker Server
Not to be confused with the "Restart Database Server" within the Admin Console
```sh
sudo systemctl stop filemaker 
sudo systemctl start filemaker 
```

# Errors
### Failed to fetch URL    Temporary failute resolving 'DOMAIN'
```sh
echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" |tee -a /etc/resolv.conf
```