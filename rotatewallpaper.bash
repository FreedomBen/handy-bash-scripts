#!/bin/bash

setrandomwallpaper () {
    if [ "$#" == "0" ]; then
        echo "Error: No images passed as args"
        return
    fi

    set -- *  
    length=$# 
    random_num=$((( $RANDOM % ($length) ) + 1 ))  

    gsettings set org.gnome.desktop.background picture-uri "file://$WP_DIR/${!random_num}" 
}


prevdir=$(pwd)

if [ -z $1 ]; then
    WP_DIR=$HOME/.wallpaper
else
    WP_DIR=$1
fi

cd $WP_DIR

setrandomwallpaper $(find $WP_DIR \( -type f -name "*.jpg" \) -or \( -type f -name "*.png" \) | xargs)

WP_DIR=$HOME/.wallpaper

cd $prevdir
