# Prep Process
- compose
- enter container
- /install/install.sh
    - Set admin credentials
- (Optional) Add SSL certificate
- image.sh (docker commit)

> Since the final image is created via docker commit, the /install volume will be defined in the image, and always mounted