#!/bin/bash


### This script is written for Ubuntu, at this point in time 13.04 ###

echo "This script will install a bunch of packages that Ben deems necessary for a proper system."

# check for root.  Don't continue if we aren't root
if [ "$(id -u)" != "0" ]; then
    echo "Cannot setup system.  Must be root."
    exit
fi

# add medibuntu repository
sudo -E wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list && sudo apt-get --quiet update && sudo apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring && sudo apt-get --quiet update

# handbrake repository
add-apt-repository ppa:stebbins/handbrake-releases

# nixnote respository (Evernote clone)
sudo add-apt-repository ppa:vincent-c/nevernote

# Gnome 3 Team repository for latest and greatest that's released
add-apt-repository ppa:gnome3-team/gnome3
# can be undone with this line, and should before doing a dist-upgrade
# ppa-purge ppa:gnome3-team/gnome3

# Ubuntu Wine team PPA
add-apt-repository ppa:ubuntu-wine/ppa

# Netflix support
add-apt-repository ppa:ehoover/compholio

# update the packages to install the latest build of the packages
apt-get -y update

# install medibuntu packages
apt-get -y install app-install-data-medibuntu 
apt-get -y install apport-hooks-medibuntu

# install common codecs
apt-get -y install non-free-codecs 
apt-get -y install libxine1-ffmpeg 
apt-get -y install gxine 
apt-get -y install mencoder 
apt-get -y install totem-mozilla 
apt-get -y install icedax 
apt-get -y install tagtool 
apt-get -y install easytag 
apt-get -y install id3tool 
apt-get -y install lame 
apt-get -y install nautilus-script-audio-convert 
apt-get -y install libmad0 
apt-get -y install mpg321 
apt-get -y install mpg123libjpeg-progs

# ability to play encrypted DVDs, install libdvdcss2
apt-get install libdvdcss2 && /usr/share/doc/libdvdread4/./install-css.sh

# support for many different compression formats
apt-get -y install unace 
apt-get -y install unrar 
apt-get -y install zip 
apt-get -y install unzip 
apt-get -y install p7zip-full 
apt-get -y install p7zip-rar 
apt-get -y install sharutils 
apt-get -y install rar 
apt-get -y install uudeview 
apt-get -y install mpack 
apt-get -y install lha 
apt-get -y install arj 
apt-get -y install cabextract 
apt-get -y install file-roller

# install the packages
apt-get -y install wine
apt-get -y install winetricks
# apt-get -y install jack
# apt-get -y install jackd
apt-get -y install linux-headers-generic
apt-get -y install terminator
apt-get -y install vim
apt-get -y install firefox
apt-get -y install pithos
apt-get -y install gcc
apt-get -y install g++
apt-get -y install openjdk-7-jre
apt-get -y install openjdk-7-jdk
apt-get -y install openssh-server
apt-get -y install openssh-client
apt-get -y install vlc
apt-get -y install libreoffice
apt-get -y install imagemagick
apt-get -y install recordmydesktop
apt-get -y install adobe-flashplugin
apt-get -y install handbrake-gtk
# apt-get -y install ardour
apt-get -y install git
apt-get -y install git-svn
apt-get -y install nmap
apt-get -y install wireshark
apt-get -y install python
apt-get -y install python3
apt-get -y install python-crypto
apt-get -y install python-qt4
apt-get -y install python-gtk2
apt-get -y install python-pip
apt-get -y install bc
apt-get -y install gpodder
apt-get -y install unetbootin
apt-get -y install xchat
apt-get -y install nautilus-dropbox
apt-get -y install calibre
apt-get -y install fbreader
apt-get -y install gimp
apt-get -y install pinta
apt-get -y install lvm2
apt-get -y install font-manager
apt-get -y install netflix-desktop
apt-get -y install hal # For Amazon Prime
apt-get -y install nixnote # evernote clone

# install Pymazon
pip install pymazon

# install dropbox
# cd $HOME/Downloads && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# $HOME/.dropbox-dist/dropboxd

# install chrome
apt-get -y install libcurl3 libnspr4-0d libxss1
cd $HOME/Downloads
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome*
rm google-chrome*

# now upgrade all existing packages.  This will probably require a reboot at the end
apt-get -y upgrade

