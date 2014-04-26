#!/bin/bash

if [ ! -d $HOME/bin ]; then
    mkdir $HOME/bin
fi

gcc txpower.c -o txpower && mv txpower $HOME/bin/ && sudo chown root:root $HOME/bin/txpower && sudo chmod +s $HOME/bin/txpower

# make symlink since I keep forgetting the name of this thing
if [ -f $HOME/bin/txpower ]; then
    PREVDIR=$(pwd)
    cd $HOME/bin && ln -s -T txpower changeTxPower
    if [ "$?" -ne 0 ]; then
        echo "Could not create symlink"
    fi
    cd $PREVDIR
fi
