#!/bin/bash


### This script is written for Ubuntu, at this point in time 13.04 ###

echo -e "This script will install a bunch of packages and stuff for developing with Django and Postgres\n"

# check for root.  Don't continue if we aren't root
if [ "$(id -u)" != "0" ]; then
    echo "Cannot setup. Must be root."
    exit
fi

# update the packages to install the latest build of the packages
apt-get -y update

# isntall Ubuntu packages
apt-get -y install virtualenv
apt-get -y install python-dev
apt-get -y install postgresql
apt-get -y install postgresql-server-dev-9.1
apt-get -y install python-psycopg2
apt-get -y install libpq-dev

# install pip packages (must be inside the virtualenv)
if [ -z "$VIRTUAL_ENV" ]; then
    echo "If you plan on using virtualenv, then I should be run from within the virtualenv environment to ensure the virtual env environment receives the right pip packages"
    read
fi

pip install django
pip install psycopg2
pip install unipath
pip install pyflakes
pip install pep8

echo -e "\nDone!  For configuring Django stuff you may find this website helpful:  https://docs.webfaction.com/software/django/config.html"

