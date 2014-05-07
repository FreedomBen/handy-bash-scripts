#!/bin/bash

XDO="xdotool"
RMD="recordmydesktop"

X_START=-1
Y_START=-1
WIDTH=-1
HEIGHT=-1

usage () 
{
    cat <<__EOF__
Starts a screen capture. Commands:
mousediff - prints out mouse location information. Does NOT start capture
start - starts capture FULL SCREEN
start mousediff - obtains mouse location information and starts capture using it
__EOF__
}

hasinstalled ()
{
    which "$1" > /dev/null 2>&1
}

dependencies ()
{
    if ! hasinstalled $XDO; then
        echo "Did not find $XDO  Installing..."
        sudo yum install $XDO
    fi

    if ! hasinstalled $RMD; then
        echo "Did not find $RMD  Installing..."
        sudo yum install $RMD
    fi

    hasinstalled $XDO && hasinstalled $RMD
}

mousediff () 
{
    read -p "Place mouse in upper left corner and press <Enter>" trash
    eval $($XDO getmouselocation --shell 2>&1 | grep -v "findclient");
    X_START="$X"
    Y_START="$Y"
    echo -e "X($X_START) Y($Y_START)\n"
    read -p "Place mouse in lower right corner and press <Enter>" trash
    eval $($XDO getmouselocation --shell 2>&1 | grep -v "findclient");
    WIDTH=$(( $X - $X_START ))
    HEIGHT=$(( $Y - $Y_START ))
    echo -e "WIDTH($WIDTH) HEIGHT($HEIGHT)\n"
}

if [ -z "$1" ] || [[ $@ =~ help ]]; then
    usage
    exit
fi

if [[ $@ =~ mousediff ]]; then
    mousediff
fi

if [[ $@ =~ start ]]; then
    if dependencies; then
        read -p "Press <Enter> to start.  <Ctrl+C> to stop: "
        if (( X_START == -1 )); then
            $RMD
        else
            $RMD -x "$X_START" -y "$Y_START" --width "$WIDTH" --height "$HEIGHT"
        fi
    else
        echo "Could not run; missing dependencies" >&2
    fi
fi


