#!/bin/bash

if [ ! -d $HOME/bin ]; then
    mkdir $HOME/bin
fi

gcc killx.c -o killx && mv killx $HOME/bin/ && sudo chown root:root $HOME/bin/killx && sudo chmod +s $HOME/bin/killx

