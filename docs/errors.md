# Errors
## Installation
### Failed to fetch URL - Temporary failure resolving 'DOMAIN'
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

> Currently strictly using named volumes, as bind mounts produce other permission errors

### Failed to Fetch
```console
E: Failed to fetch http://[SOME-PACKAGE-URL].deb  404  Not Found [IP: SOME.IP]
E: Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?
```
As suggested, `apt-get update` seems to fix the issue

### It was not possible to open the Devin Engine in fmsadmin
Not sure of the cause, entering the `/tmp/install_devin` directory within the `fms-prep` container may fix it.<br>
Also note that the devin installation log is created within the terminal's context.
> Install script now enters the container and instructs the user to execute the devin installation

## Compose
### Port not available
To find which service is taking up a port, use `sudo lsof -l :<port>`.<br>
You can kill those services using `sudo kill -9 <PID>`, but you should exhaust the proper operations first

#### Port 5003
If FileMaker Pro is running, close it and try again, you'll be able to open it afterwards.

#### Port 443
Some service is taking up port 443. If this is FileMaker Server, use `systemctl` or `launchctl` to stop it.<br>
- Linux: `sudo systemctl (stop/start) fmshelper`
- MacOS: `sudo launchctl (stop/start) com.filemaker.fms`

## Devin
### Cannot connect to Engine (Unknown). Make sure FileMaker Server is running and that the URL is correct.
Make sure the container and fmshelper service within it are up, and container port 5003 is accessible.

### Go to Hosts -> Show Hosts, add the server, tick 'always permit connection...' and try again.
The database server is not encrypted, upload an SSL certificate using the admin console (https://DOMAIN/admin-console).<br>
Then, re-compose the container with 
```sh
docker compose down fms
docker compose up -d fms
```

### Deployment - `Couldn't open the source file because "(804) : File cannot be opened as read only in its current state."`
See [file permissions](#file-not-modifiable)

## FileMaker Pro
### File Not Modifiable
Make sure the container has permissions to access the database file.<br>
Set the file ownership using `chown fmsrver:fmsadmin filemakerapp.fmp12`
