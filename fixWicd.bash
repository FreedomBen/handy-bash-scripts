#!/bin/bash


### This script is written for Ubuntu, at this point in time 13.04 ###

echo -e "This script will fix a symlink issue with wicd."

# check for root.  Don't continue if we aren't root
if [ "$(id -u)" != "0" ]; then
    echo "Cannot setup. Must be root. Please rerun using sudo"
    exit
fi

# update the packages to install the latest build of the packages
RESOLV_FILE='/var/lib/wicd/resolv.conf.orig'
RESOLV_FILE_BACKUP="${RESOLV_FILE}.backup"
TARGET='/run/resolvconf/resolv.conf'

if [ -f "$TARGET" ]; then

    if [ -f "$RESOLV_FILE" ]; then
        mv "$RESOLV_FILE" "$RESOLV_FILE_BACKUP"
        ln -s -T "$TARGET" "$RESOLV_FILE"
        echo "Done. The original file $RESOLV_FILE is backed up as $RESOLV_FILE_BACKUP"
    else
        echo "Could not find $RESOLV_FILE"
        exit 1
    fi

else
    echo "$TARGET does not exist!  Lots of stuff is probably broken"
    exit 1
fi
