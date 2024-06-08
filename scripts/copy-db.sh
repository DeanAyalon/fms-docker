# Help dialog
help() {
    echo Use: $0 [path]
    echo Warning! Overrides existing files!
}

# Specify filepath
if [ -z "$1" ]; then
    help
    exit 1
elif [ $1 = "-h" ]; then        # Temporary, until flags are added
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
docker cp "$dbname" "fms:$innerpath"
$cmd chown fmserver:fmsadmin "$innerpath/$dbname"
$cmd ls -l "$innerpath"

# Possible plans:
# - Prompt to change name
# - Allow -c flag to copy Devin commits?
