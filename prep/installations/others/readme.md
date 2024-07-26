This directory exists in order to install any other files (Such as custom fonts, extensions, etc.) on the FMS image

After running the `install.sh` script on the fms-prep container, manually install the custom files placed here
To enter the container's shell interactively, use `docker exec -it fms-prep /bin/bash`

Data within this directory is gitignored and will not be kept in the repository

# Fonts
To install fonts, copy them over to `/usr/share/fonts`

For example, the font family 'FontName':
- FontName/
    - FontName-Bold.ttf
    - FontName-Regular.ttf

Would be located in `/usr/share/fonts/truetype/FontName/*`

List installed fonts: `fc-list`<br>
Refresh font list: `fc-cache -fv`