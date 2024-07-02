# Help dialog
help() {
cat << EOF
    Use: $0 [options] [path]
    Copies a database into the container and handles permissions

    Options:
        -h  Display this help dialog
    
    NOT YET IMPLEMENTED:
        -n  Change the name of this database before copying
        -d  Copy the db to a custom database directory
        -S  Copy the db to the Secure database directory
        -c  Copy Devin.fm commits to their respective directory
EOF
}

# Specify filepath
if [ -z "$1" ]; then
    help
    exit 1
elif [ "$1" = "-h" ]; then        # Temporary, until flags are added
    help
    exit 2
fi

# Database name
path="$1"
cd "$(dirname "$path")"
pwd
dbname=${path##*/}
echo $dbname

# Container path
innerpath="/opt/FileMaker/FileMaker Server/Data/Databases"
    # TODO innerpath may need to be able to lead to the Secure folder to encrypt the database
        # -e for encrypted files
        # TODO use fmsadmin commands to add the encrypted key automatically?
cmd="docker exec -itu0 fms"

# Copy and change permissions
exists=$(docker exec fms [ -f "/$innerpath/$dbname" ] && echo true || echo false)
if [ $exists = true ]; then
    echo "This file already exists, would you like to replace it? [y/N]"
    read replace
    [ -z $replace ] || ([ $replace != "y" ] && [ $replace != "Y" ]) && exit 0
    echo Replacing...
fi

docker cp "$dbname" "fms:$innerpath"
$cmd chown fmserver:fmsadmin "$innerpath/$dbname"
$cmd ls -l "$innerpath"

# Possible plans:
# - Prompt to change name
# - Copy to Secure or other directories
# - Allow -c flag to copy Devin commits?
