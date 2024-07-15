This directory exists in order to install any other files (Such as custom fonts, extensions, etc.) on the FMS image

After running the `install.sh` script on the fms-prep container, manually install the custom files placed here

Data within this directory is gitignored and will not be kept in the repository

# Fonts
Not sure yet where to install, need ME version of FMS to test this<br>
Possible locations:
- `/usr/share/fonts/truetype` - Seems to work, but FMS still doesn't use the font. Email sent to Claris support

Alternate possibilities
- `~/.fonts` 
- `~/.local/share/fonts`
 
To list installed fonts, use `fc-list`