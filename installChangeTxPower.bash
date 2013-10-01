#!/bin/bash

if [ ! -d $HOME/bin ]; then
    mkdir $HOME/bin
fi

gcc changeTxPower.c -o changeTxPower && mv changeTxPower $HOME/bin/ && sudo chown root:root $HOME/bin/changeTxPower && sudo chmod +s $HOME/bin/changeTxPower

