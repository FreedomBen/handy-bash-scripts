#!/bin/bash

declare -r color_restore='\033[0m'
declare -r color_light_red='\033[1;31m'
declare -r color_red='\033[0;31m'
declare -r color_yellow='\033[1;33m'
declare -r color_blue='\033[0;34m'
declare -r color_light_blue='\033[1;34m'
declare -r color_light_green='\033[1;32m'
declare -r color_green='\033[0;32m'

isLinux ()
{
    uname -a | grep "Linux" > /dev/null 2>&1
}

OOM_VAL=990

if [ "$(id -u)" != "0" ]; then
    echo "Must be run as root" >&2
    exit
fi


if [ -z "$1" ]; then
    echo "Error: no processes to pgrep for. I need a name" >&2
    exit
fi

if [ -z "$2" ]; then
    echo "No value passed. Using default of $OOM_VAL (this process gets killed first)"
else
    OOM_VAL="$2"
fi


for i in $(pgrep "$1"); do
    WAS="$(cat /proc/$i/oom_score_adj)"
    # echo -e "${color_blue}Setting process $i oom_score_adj to $OOM_VAL${color_restore}"
    if isLinux; then
        echo -e "${color_light_blue}Setting process $i ($(cat /proc/$i/comm)) - ${color_blue}($(cat /proc/$i/cmdline)) ${color_light_blue}oom_score_adj to $OOM_VAL${color_restore}"
    else
        echo -e "${color_blue}Setting process $i ($(ps -p $i -o comm=)) oom_score_adj to $OOM_VAL${color_restore}"
    fi
    echo "$OOM_VAL" > /proc/$i/oom_score_adj
    IS="$(cat /proc/$i/oom_score_adj)"
    
    if [ "$IS" = "$OOM_VAL" ]; then
        color=$color_green
        numcolor=$color_light_green
    elif [ "$WAS" = "$IS" ]; then
        color=$color_red
        numcolor=$color_light_red
    else
        color=$color_yellow
        numcolor=$color_restore
    fi

    echo -e "${color}Actual setting was ${numcolor}${WAS}${color} is now ${numcolor}${IS}${color_restore}"
done
