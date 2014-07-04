#!/bin/bash

### This script is written for Arch Linux ###

# check for root.  Don't continue if we are root
if [ "$(id -u)" = "0" ]; then
    echo "This script must NOT be run as root."
    exit 1
fi

echo "You should run this script after running the as-root script."
echo "Press <Enter> to proceed or Ctrl+C to cancel"
read


# generate SSH keys if necessary
if [ -f "$HOME/.ssh/id_rsa.pub" ]; then
    read -p "You don't yet have SSH keys.  Generate some?: " SSH
    
    if [ "$SSH" == "y" -o "$SSH" == "Y" ]; then
        prevdir=$(pwd)
        cd "$HOME/.ssh"
        ssh-keygen
        cd $prevdir
    fi
else
    echo "Already have SSH keys.  Not generating new ones"
fi

# setup the xinit
read -p "Did you install Gnome?: " GNOME

if [ "$GNOME" = "Y" -o "$GNOME" = "y" ]; then
    if [ -f /etc/skel/.xinitrc ]; then
        cp /etc/skel/.xinitrc $HOME/ 
        echo "exec gnome-session" >> $HOME/.xinitrc
    else
        echo "No .xinitrc found in /etc/skel!"
    fi

    # set some common configuration options

    echo "Writing dconf settings for non-attached modal dialogs"
    # Don't attach modal dialogs
    dconf write /org/gnome/shell/overrides/attach-modal-dialogs false

    echo "Writing dconf settings for log out option if only one user exists"
    # Show a logout option even if there's only one user that exists
    dconf write /org/gnome/shell/always-show-log-out true
fi

