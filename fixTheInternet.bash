#!/bin/bash

echo "This script will temporarily disable your ethernet connection and wireless N.  This fixes a wireless N issue that Linux has with some routers.  You will need to enter your sudo password when prompted."

sudo ifconfig eth0 down
echo "Putting eth0 down"

sudo modprobe -r iwlwifi
echo "Removing iwlwifi module"

sudo modprobe iwlwifi 11n_disable=1
echo "Reinsterting iwlwifi module with n disabled"

echo "Done!"

