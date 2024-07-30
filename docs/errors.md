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

### Devin - It was not possible to validate your admin account credentials, please try again.
If the credentials entered were correct, but Devin still could not connect, try restarting the prep container
```sh
docker restart fms-prep
./prep/install.sh
```
> This may also be characterized by the Devin installer being very slow

## Compose
### Port not available
To find which service is taking up a port, use `sudo lsof -l :<port>`.<br>
You can kill those services using `sudo kill -9 <PID>`, but you should exhaust the proper operations first

#### Port 5003
If FileMaker Pro is running, close it and try again, you'll be able to open it afterwards.

#### Port 443
Some service is taking up port 443. If this is FileMaker Server, use `systemctl` or `launchctl` to stop it.<br>
- **Linux**: `sudo systemctl (stop/start) fmshelper`
- **MacOS**: `sudo launchctl (stop/start) com.filemaker.fms`

## Devin
### Cannot connect to Engine (Unknown). Make sure FileMaker Server is running and that the URL is correct.
Make sure the container and fmshelper service within it are up, and container port 5003 is accessible.

### Connecting to Engine - Runs forever
The certificate may be wrong, if you want to trust the server anyway, enter the hosts menu and permit connection to the server.

### Go to Hosts -> Show Hosts, add the server, tick 'always permit connection...' and try again.
The database server is not encrypted, upload an SSL certificate using the admin console (https://DOMAIN/admin-console).<br>
Then, re-compose the container with 
```sh
docker compose down fms
docker compose up -d fms
```

### Connection Error alert when actually got a good connection
This would mean some request to the server has failed, it is currently not showing the actual error, but 'Connection Error' instead<br>

Checking the container's Devin error logs (/opt/Devin/logs/handler_err.log), the error seemed to be write permissions to the log files<br>
The correct file ownership is `devin:fmsadmin`, editing the file (Like manually clearing it) may result in the ownership changing

### Deployment - `Couldn't open the source file because "(804) : File cannot be opened as read only in its current state."`
See [file permissions](#file-not-modifiable)

### Deployment stuck
Check the container's Devin log files (/opt/Devin/logs/devin.log)

#### Error 413 - Files Too Large
```log
[timestamp] - urllib3.connectionpool - DEBUG - https://your.production.fms:443 "POST /devin/api/v1/prod/migration/devin-migration-hash/upload HTTP/1.1" 413 183
```

When using a reverse-proxy, make sure large files are allowed to be uploaded.
- Nginx default upload limit is **1 MiB**, change it using `client_max_body_size 100M;`

## FileMaker Pro
### File Not Modifiable
Make sure the container has permissions to access the database file.<br>
Set the file ownership using `chown fmsrver:fmsadmin filemakerapp.fmp12`

### External Files - Saved in Wrong Directory, or "Unable to write to file system" Error
If FileMaker creates the path `/opt/FileMaker/FileMaker Server/Data/Databases/Base Software` within the fms container, instead of saving the external files within `/opt/FileMaker/FileMaker Server/Data/Databases/RC_Data_FMS` directory that is bound to $FILES_MOUNT<br>
This is likely due to lack of write permissions to the mounted directory - The directory should allow write permission to the group.
```sh
chmod g+w [bind/mount/path]
# or
chmod 770 [bind/mount/path]
```

> Executing `ls -l` should result in:<br>
> `drwxrwx--- ... <user> <group> ... <directory>`

### External Files - No Host Access
If your host machine does not have access to read the files within the bind mount, this may be due to the ownership configuration of the directory.<br>
If the path on the host was created by Docker Compose, the default ownership assigned to the directory would be `root:root`.

Changing the ownership of the directory should allow host access without harming the container's permissions
```sh
sudo chown $USER:root [bind/mount/path]
# OR
sudo chown $USER:$USER [bind/mount/path]
```

Alternatively, if this does not work, change the ownership to the container's user:group, and allow write access to the group:
```sh
sudo chown fmserver:fmsadmin [path]
sudo chmod 770 [path]
```