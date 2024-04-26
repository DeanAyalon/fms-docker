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
- `enter fms-ver-prep`, `cd /install`, install.sh 
    > TODO: Put this into the compose script, call it install?
- image.sg

final
- compose.sh

# Certificates
> TODO: Check about automatic installation

- Login to the [admin console](https://localhost/admin-console) and import the certificate files
- Restart FileMaker Server
```
sudo systemctl stop filemaker 
sudo systemctl start filemaker 
```