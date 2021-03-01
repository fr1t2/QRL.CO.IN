#!/bin/bash

##################################################
# Backup to digital ocean spaces
#
#
#
##################################################
SRC=$1
showhelp(){
        echo "\n#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+"
        echo "# DO_backup.sh                         #+"
        echo "#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+#+"
        echo "\nThis script will backup files/folders already tared to the store listed"
        echo "In order to work, this script needs the following 2 parameters in the listed order: "
        echo "\t- The full path for the folder or file you want to backup."
        echo "\t- The name of the Space where you want to store the backup at (not the url, just the name)."
        echo "Example: sh DO_backup.sh ./testdir testSpace\n"
}

movetoSpace(){
    echo "\n##### MOVING TO SPACE #####\n"
    if s3cmd put $SRC s3://qrl-chain.fra1.digitaloceanspaces.com --host-bucket s3://qrl-chain.fra1.digitaloceanspaces.com -P --access_key RP3QCK7BMDVCCSPZXJHR --secret_key 0mEluDe7VjChSRjWhOQCk5mAHVIaM/PWRpPr/utKEg4; then
        echo "\n##### Done moving files to s3://"$DST" #####\n"
        return 0
    else
        echo "\n##### Failed to move files to the Space #####\n"
        return 1
    fi
}
if [ ! -z "$SRC" ]; then
    movetoSpace  
else
    showhelp
fi
