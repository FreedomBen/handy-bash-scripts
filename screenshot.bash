#!/bin/sh
if [ -z $1 ]; then
    sleep="7"
else
    sleep="$1"
fi

if [ -z $2 ]; then
    out="$HOME/screenshot.png"
else
    out="$2"
fi

sleep $sleep;
import $HOME/screenshot.png
eog $HOME/screenshot.png
