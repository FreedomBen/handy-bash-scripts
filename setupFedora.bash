#!/bin/bash


### This script is written for Fedora 20 ###

echo "This script will install a bunch of packages that Ben deems necessary for a proper system."

# check for root.  Don't continue if we aren't root
if [ "$(id -u)" != "0" ]; then
    echo "Cannot setup system.  Must be root."
    exit
fi

read -p "Do you want to install Netflix?: " NETFLIX
read -p "Do you want to install Dropbox?: " DROPBOX

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

# add RPMFusion Free and Nonfree
yum localinstall --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


# Netflix
if [ "$NETFLIX" == "y" -o "$NETFLIX" == "Y" ]; then
    yum -y install http://sourceforge.net/projects/postinstaller/files/fedora/releases/19/x86_64/updates/wine-silverligh-1.6-3.fc19.x86_64.rpm
    yum -y install http://sourceforge.net/projects/postinstaller/files/fedora/releases/19/x86_64/updates/netflix-desktop-0.7.0-7.fc19.noarch.rpm
fi


# Dropbox
if [ "$DROPBOX" == "y" -o "$DROPBOX" == "Y" ]; then
    prevdir=$(pwd)
    cd $HOME/Downloads && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
    $HOME/.dropbox-dist/dropboxd
    cd $prevdir
fi


# Oracle Virtual Box
read -r -d '' VAR <<"EOF"
[virtualbox]
name=Fedora $releasever - $basearch - VirtualBox
baseurl=http://download.virtualbox.org/virtualbox/rpm/fedora/$releasever/$basearch
enabled=1
gpgcheck=1
gpgkey=http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc
EOF
echo "$VAR" > /etc/yum.repos.d/virtualbox.repo


# Add Google-Chrome repo
read -r -d '' VAR <<"EOF"
[google-chrome]
name=google-chrome - 64-bit
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF
echo "$VAR" > /etc/yum.repos.d/google-chrome.repo


# Add Insync repo
rpm --import https://d2t3ff60b2tol4.cloudfront.net/repomd.xml.key
read -r -d '' VAR <<"EOF"
[insync]
name=insync repo
baseurl=http://yum.insynchq.com/fedora/
gpgcheck=1
gpgkey=https://d2t3ff60b2tol4.cloudfront.net/repomd.xml.key
enabled=1
repo_gpgcheck=1
metadata_expire=120m
EOF
echo "$VAR" > /etc/yum.repos.d/insync.repo


# Insync prompts the user so get that installed early
yum -y install insync


# group installs
yum -y groupinstall "Development Tools"
yum -y groupinstall "C Development Tools and Libraries"
yum -y groupinstall "Books and Guides"
yum -y groupinstall "RPM Development Tools"
yum -y groupinstall "Sound and Video"
yum -y groupinstall "LibreOffice"
yum -y groupinstall "Security Lab"


yum -y install vim
yum -y install audacity
yum -y install google-chrome-stable
yum -y install xclip
yum -y install dconf-editor
yum -y install gnome-tweak-tool
yum -y install xclip

yum -y install dkms
yum -y install VirtualBox-4.3



# support for many different compression formats
yum -y install unace 
yum -y install unrar 
yum -y install zip 
yum -y install unzip 
yum -y install p7zip-full 
yum -y install p7zip-rar 
yum -y install sharutils 
yum -y install rar 
yum -y install uudeview 
yum -y install mpack 
yum -y install lha 
yum -y install arj 
yum -y install cabextract 
yum -y install file-roller

# install the packages
yum -y install wine
yum -y install winetricks
yum -y install linux-headers-generic
yum -y install terminator
yum -y install vim
yum -y install firefox
yum -y install pithos
yum -y install openjdk-7-jre
yum -y install openjdk-7-jdk
yum -y install openssh-server
yum -y install openssh-client
yum -y install vlc
yum -y install imagemagick
yum -y install adobe-flashplugin
yum -y install handbrake-gtk
yum -y install git
yum -y install git-svn
yum -y install nmap
yum -y install wireshark
yum -y install python
yum -y install python3
yum -y install python-crypto
yum -y install python-qt4
yum -y install python-gtk2
yum -y install python-pip
yum -y install bc
yum -y install gpodder
yum -y install unetbootin
yum -y install xchat
yum -y install nautilus-dropbox
yum -y install calibre
yum -y install fbreader
yum -y install gimp
yum -y install pinta
yum -y install lvm2
yum -y install font-manager
yum -y install transmission
# yum -y install deluge

# install Pymazon
pip install pymazon


# now upgrade all existing packages.  This will probably require a reboot at the end
yum -y update

