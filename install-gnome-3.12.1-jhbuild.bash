#!/bin/bash

die ()
{
    echo "ERROR: $1"
    exit 1
}

read -p "Build webkit? (Can take a couple hours and not required for most) (Y/N): " WEBKIT

read -p "Skip installing build dependencies? (Saying yes will skip to building)?: " SKIP

if ! [[ "$SKIP" =~ [Yy] ]]; then
    sudo yum install -y @development-tools @gnome-software-development
    sudo yum install -y dotconf-devel exiv2-devel spice-protocol gtkspell3-devel gc-devel python-rdflib bogofilter spamassassin libunistring-devel gpgme-devel file-devel espeak-devel ppp-devel cracklib-devel cups-devel mpfr-devel libwebp-devel wireless-tools-devel ppp mpfr ragel cracklib cups gperf libtool-ltdl-devel intltool mozjs17-devel libnl3-devel libuuid-devel mtdev-devel libusb-devel lcms2-devel libatasmart-devel libsndfile-devel json-c-devel libvorbis-devel gmime-devel libxslt-devel python3-cairo-devel libarchive-devel cairomm-devel libXtst-devel libXt-devel xkeyboard-config-devel xorg-x11-drv-wacom-devel icon-naming-utils xorg-x11-xtrans-devel avahi-gobject-devel libdvdread-devel
fi

if [ -d ~/gitclone ]; then
    cd ~/gitclone
fi

mkdir -p ~/.local/bin

if [ ! -d jhbuild ]; then
    git clone git://git.gnome.org/jhbuild
    GITPULL=N
else
    read -p "Do a git pull on jhbuild now?: " GITPULL
fi


cd jhbuild 

if [ "$GITPULL" = "y" -o "$GITPULL" = "Y" ]; then
    git pull --rebase
fi

./autogen.sh || die "Error configuring jhbuild"
make || die "Error building jhbuild"
make install || die "Error installing jhbuild"


NEEDS_PATH_APP=1
if [[ $PATH =~ \.local/bin ]]; then
    NEEDS_PATH_APP=0
else
    while read line; do
        if [[ $line =~ \.local/bin ]]; then
            NEEDS_PATH_APP=0
        fi
    done < ~/.bashrc
fi

if (( $NEEDS_PATH_APP )); then
    echo 'PATH=$PATH:~/.local/bin' >> ~/.bashrc
    . ~/.bashrc
fi


mkdir -p ~/.config
read -r -d '' VAR << "__EOF__"

# -*- mode: python -*-
# -*- coding: utf-8 -*-

moduleset = [ 'http://ftp.gnome.org/pub/GNOME/teams/releng/3.12.1/gnome-apps-3.12.1.modules',
    'http://ftp.gnome.org/pub/GNOME/teams/releng/3.12.1/gnome-suites-core-3.12.1.modules',
    'http://ftp.gnome.org/pub/GNOME/teams/releng/3.12.1/gnome-suites-core-deps-3.12.1.modules',
    'http://ftp.gnome.org/pub/GNOME/teams/releng/3.12.1/gnome-sysdeps-3.12.1.modules'
    ]

# A list of the modules to build.  Defaults to the GNOME core and tested apps.
modules = [ 'meta-gnome-core', 'meta-gnome-core-shell' ]

# what directory should the source be checked out to?
checkoutroot = '~/jhbuild/checkout'

# the prefix to configure/install modules to (must have write access)
prefix = '~/jhbuild/install'

nice_build = True

__EOF__

echo "$VAR" > ~/.config/jhbuildrc

if [[ "$WEBKIT" =~ [Yy] ]]; then
    echo "skip = ['WebKit'] # required for Epiphany but not basic gnome-shell" >> ~/.config/jhbuildrc
fi


if ! $(which jhbuild > /dev/null 2>&1); then
    PATH=$PATH:~/.local/bin
fi

jhbuild sysdeps --install || die "Error installing jhbuild sysdeps"
jhbuild build || die "Error building jhbuild"

if [ "$?" != "0" ]; then
    read -p "The build process is complete but some errors occurred.  Proceed with installation?" response
    if ! [[ "$response" =~ [yY] ]]; then
         exit 1  
    fi
fi

mkdir -p ~/jhbuild/install/var/run || die "Error making required dir"
sudo mkdir -p /var/run/dbus || die "Error making required dir"
sudo mkdir -p /var/lib/dbus || die "Error making required dir"
mkdir -p ~/jhbuild/install/var/lib/dbus || die "Error making required dir"

rm -rf ~/jhbuild/install/var/run/dbus
sudo ln -s /var/run/dbus ~/jhbuild/install/var/run/dbus || die "Error making symlink"
rm -rf ~/jhbuild/install/var/lib/dbus/machine-id
sudo ln -s /var/lib/dbus/machine-id ~/jhbuild/install/var/lib/dbus/machine-id || die "Error smking symlink"


mkdir -p ~/.config
read -r -d '' VAR << "__EOF__"
#!/bin/sh

GNOME=~/jhbuild/install
 
GDK_USE_XFT=1
XDG_DATA_DIRS=$XDG_DATA_DIRS:$GNOME/share
XDG_CONFIG_DIRS=$XDG_CONFIG_DIRS:$GNOME/etc/xdg

jhbuild run gnome-session

__EOF__

sudo echo "$VAR" > /usr/bin/gnome-jhbuild-session || die "Could not write /usr/bin/gnome-jhbuild-session script"
sudo chmod a+x /usr/bin/gnome-jhbuild-session || die "Could not make session script executable"


mkdir -p ~/.config
read -r -d '' VAR << "__EOF__"
[Desktop Entry]
Name=GNOME (JHBuild)
Comment=This session logs you into GNOME testing session
TryExec=/usr/bin/gnome-jhbuild-session
Exec=/usr/bin/gnome-jhbuild-session
Icon=
Type=Application

__EOF__

sudo echo "$VAR" > /usr/share/xsessions/gnome-jhbuild.desktop || die "Could not write gnome-jhbuild.desktop"

read -p "Ok, we're ready to restart GDM.  This will wipe out your current X session and give you the jhbuild gnome option.  Type yes in all caps when ready: " response

if [ $response =~ YES ]; then
    sudo systemctl restart gdm
else
   echo "No problem, when you're ready, run: sudo systemctl restart gdm"
fi

exit 0

