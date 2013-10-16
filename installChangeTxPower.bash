#!/bin/bash

if [ ! -d $HOME/bin ]; then
    mkdir $HOME/bin
fi

gcc changeTxPower.c -o changeTxPower && mv changeTxPower $HOME/bin/ && sudo chown root:root $HOME/bin/changeTxPower && sudo chmod +s $HOME/bin/changeTxPower

# make symlink since I keep forgetting the name of this thing
if [ -f $HOME/bin/changeTxPower ]; then
    PREVDIR=$(pwd)
    cd $HOME/bin && ln -s -T changeTxPower txpower
    if [ "$?" -ne 0 ]; then
        echo "Could not create symlink"
    fi
    cd $PREVDIR
fi
