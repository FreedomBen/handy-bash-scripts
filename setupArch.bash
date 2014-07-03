#!/bin/bash

### This script is written for Arch Linux ###

aurinstall ()
{
    AUR_DIR="$HOME/aur"
    AUR_BUILD_DIR="$AUR_DIR/build"
    AUR_TARBALLS_DIR="$AUR_DIR/tarballs"
    AUR_ARCHIVE_DIR="/var/cache/aur"

    mkdir -p "$AUR_TARBALLS_DIR"

    prevdir=$(pwd)

    use_cower=0
    if [ -f "$1" ]; then
        [ "$1" -ef "$AUR_TARBALLS_DIR/$(basename $1)" ] || cp "$1" "$AUR_TARBALLS_DIR/"
    elif [[ "$1" =~ ^http ]]; then
        cd "$AUR_TARBALLS_DIR"
        curl -O "$1"
    else
        use_cower=1
    fi

    if (( $use_cower )); then
        if $(which cower > /dev/null 2>&1); then
            cd $AUR_BUILD_DIR
            cower -d -d "$1"
            output_dir="$1"
        else
            echo "cower is not installed, and you did not pass a tarball or URL. Cannot install package"
            exit 1
        fi
    else
        tarball="$(basename $1)"
        # output_dir="$(echo $tarball | sed -e 's/\.t.*//g')" # To support .tgz files
        output_dir="$(echo $tarball | sed -e 's/\.tar.*//g')"
        cd "$AUR_BUILD_DIR"
        tar xf "$AUR_TARBALLS_DIR/$tarball"
    fi

    cd "$output_dir"
    makepkg --clean --syncdeps --needed --noconfirm --install
    sudo cp *.tar.* "$AUR_ARCHIVE_DIR"
}


echo "This script will install a bunch of packages that Ben deems necessary for a proper system."

# check for root.  Don't continue if we aren't root
if [ "$(id -u)" != "0" ]; then
    echo "Cannot setup system.  Must be root."
    exit
fi

read -p "Do you want to install a graphical environment (Gnome)?: " GNOME

NETMAN=n
if [ "$GNOME" = "Y" -o "$GNOME" = "y" ]; then
    read -p "Do you want to install Network Manager?: " NETMAN
fi

read -p "Do you want to install libvirt/KVM?: " LIBVIRT

# read -p "Do you want to install Netflix?: " NETFLIX
# read -p "Do you want to install Dropbox?: " DROPBOX
# read -p "Do you want to install Handbrake?: " HANDBRAKE

# generate SSH keys if necessary
if [ -f "$HOME/.ssh/id_rsa.pub" ]; then
    read -p "You don't yet have SSH keys.  Generate some?: " SSH
    
    if [ "$SSH" == "y" -o "$SSH" == "Y" ]; then
        prevdir=$(pwd)
        cd "$HOME/.ssh"
        ssh-keygen
        cd $prevdir
    fi
fi


# Insync prompts the user so get that installed early
yum -y install insync insync-nautilus

# profile-sync-daemon (config needed in /etc/psd.conf
yum -y install profile-sync-daemon


# Full repo sync and system upgrade
pacman -Syu --noconfirm


# Install non-graphical stuff
pacman -S --noconfirm --needed base-devel
pacman -S --noconfirm --needed iproute2 iw wpa_supplicant
pacman -S --noconfirm --needed vim
pacman -S --noconfirm --needed git
pacman -S --noconfirm --needed xclip
pacman -S --noconfirm --needed dcfldd
pacman -S --noconfirm --needed unrar
pacman -S --noconfirm --needed nmap
pacman -S --noconfirm --needed wireshark-gtk
pacman -S --noconfirm --needed python-pip
pacman -S --noconfirm --needed python-crypto
pacman -S --noconfirm --needed bc
pacman -S --noconfirm --needed linux-headers
pacman -S --noconfirm --needed htop
pacman -S --noconfirm --needed lsof
pacman -S --noconfirm --needed p7zip

# if we install network manager then we don't want this
if ! [ "$NETMAN" = "Y" -o "$NETMAN" = "y" ]; then
    pacman -S --noconfirm --needed ntp
fi


# Install graphical stuff
if [ "$GNOME" = "Y" -o "$GNOME" = "y" ]; then
    pacman -S --noconfirm --needed gnome
    pacman -S --noconfirm --needed terminator
    pacman -S --noconfirm --needed gedit
    pacman -S --noconfirm --needed gnome-tweak-tool
    pacman -S --noconfirm --needed recordmydesktop
    pacman -S --noconfirm --needed xdotool
    pacman -S --noconfirm --needed imagemagick imagemagick-doc
    pacman -S --noconfirm --needed eog
    pacman -S --noconfirm --needed qalculate-gtk # a freaking awesome calculator
    pacman -S --noconfirm --needed dconf
    pacman -S --noconfirm --needed firefox
    pacman -S --noconfirm --needed transmission-gtk
    pacman -S --noconfirm --needed vlc
    pacman -S --noconfirm --needed libdvdcss
    pacman -S --noconfirm --needed ttf-freefont
    pacman -S --noconfirm --needed unetbootin
    pacman -S --noconfirm --needed fbreader
    pacman -S --noconfirm --needed xchat
    pacman -S --noconfirm --needed gimp
    pacman -S --noconfirm --needed pinta


    # Install Network Manager
    # If Network Manager needs to be disabled, it should be masked because it automatically starts through dbus
    # systemctl mask NetworkManager
    # systemctl mask NetworkManager-dispatcher

    if [ "$NETMAN" = "Y" -o "$NETMAN" = "y" ]; then
        pacman -S --noconfirm --needed networkmanager network-manager-applet
        pacman -S --noconfirm --needed networkmanager-dispatcher-openntpd

        systemctl enable NetworkManager
        systemctl enable NetworkManager-dispatcher.service

        echo "dhcp=dhcpcd" >> /etc/NetworkManager/NetworkManager.conf
    fi
fi


# Install libvirt
if [ "$LIBVIRT" = "Y" -o "$LIBVIRT" = "y" ]; then
    echo "Libvirt install not implemented"
fi


# If Nvidia graphics card:
# pacman -S --noconfirm libva-vdpau-driver

# If Intel graphics card:
# pacman -S --noconfirm libva-intel-driver


aurinstall "https://aur.archlinux.org/packages/co/cower/cower.tar.gz"
aurinstall profile-sync-daemon
aurinstall anything-sync-daemon
aurinstall libgcrypt15
aurinstall python-pylast
aurinstall ttf-ms-fonts
aurinstall pithos
aurinstall google-chrome


# Enable desired services
echo "Enabling and starting ntpd..."
systemctl enable ntpd
systemctl start ntpd


# mp3 and other codec needs
# yum -y k3b k3b-extras-freeworld #extras required for mp3 ripping/burning
# yum -y install gstreamer-plugins-espeak
# yum -y install gstreamer-plugins-base
# yum -y install gstreamer-plugins-ugly
# yum -y install gstreamer-plugins-bad
# yum -y install gstreamer-plugins-good
# yum -y install gstreamer-plugins-bad-free
# yum -y install gstreamer-plugins-bad-free-extras
# yum -y install gstreamer-plugins-bad-nonfree
# yum -y install gstreamer-plugins-good-extras


# set some common configuration options

echo "Writing dconf settings for non-attached modal dialogs"
# Don't attach modal dialogs
dconf write /org/gnome/shell/overrides/attach-modal-dialogs false

echo "Writing dconf settings for log out option if only one user exists"
# Show a logout option even if there's only one user that exists
dconf write /org/gnome/shell/always-show-log-out true

