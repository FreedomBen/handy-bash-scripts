#!/bin/bash

gcc changeTxPower.c -o changeTxPower && mv changeTxPower $HOME/bin/ && sudo chown root:root $HOME/bin/changeTxPower && sudo chmod +s $HOME/bin/changeTxPower

