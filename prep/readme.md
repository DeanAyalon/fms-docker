# Prep Process
- compose: `docker compose up -d fms-prep`
- [install script](./install.sh) - Executes the installation script within the container
    - The mounted install.sh might no longer be needed - unless Claris changes its install file naming convention
- (Optional) Add SSL certificate - Can also be done after running the finalized image
- [image script](./image.sh) (docker commit)

> Since the final image is created via docker commit, the /install volume will be defined in the image, and always mounted