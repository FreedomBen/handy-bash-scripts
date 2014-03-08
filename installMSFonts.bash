#!/bin/sh

if [ "$(id -u)" != "0" ]; then
    echo "Must be root.  Re-run with sudo"
    exit
fi

# check for dependencies
if ! $(which cabextract); then
    yum -y install cabextract
fi

if ! $(which wget); then
    yum -y install wget
fi

if ! $(which rpmbuild); then
    yum -y install rpm-build
fi

if ! $(which ttmkfdir); then
    yum -y install ttmkfdir
fi

wget http://corefonts.sourceforge.net/msttcorefonts-2.5-1.spec
rpmbuild -bb msttcorefonts-2.5-1.spec
rpm -ivh $HOME/rpmbuild/RPMS/noarch/msttcorefonts-2.5-1.noarch.rpm
fc-cache -f -v

