#!/bin/bash

# Ignore repos (grep regex)
ONE='webgoat'
TWO='django$'
THREE='practice'
FOUR='linux-stable'
FIVE='updf'
SIX='wordament'
SEVEN='rss-fixer'

onIgnoreList () 
{
    echo "$1" | grep "$ONE" > /dev/null && return 0
    echo "$1" | grep "$TWO" > /dev/null && return 0
    echo "$1" | grep "$THREE" > /dev/null && return 0
    echo "$1" | grep "$FOUR" > /dev/null && return 0
    echo "$1" | grep "$FIVE" > /dev/null && return 0
    echo "$1" | grep "$SIX" > /dev/null && return 0
    echo "$1" | grep "$SEVEN" > /dev/null && return 0
    return 1
}

for file in $(find . -maxdepth 1 -type d)
do
    echo -en "\033[0;34mUpdating ${file}: \033[0m"
    if [ -d ${file}/.git ]; then
        if onIgnoreList "${file}"; then
            echo -e "\033[1;33mRepo on ignore list: ${file}\033[0m"
        else
            echo -e "\033[0;34mPlease enter credentials if requested\033[0m"
            oldDir=$(pwd)
            cd $file
            git pull -r && git push
            cd $oldDir
        fi
    else
        echo -e "\033[0;31mNo Git repo in this folder\033[0m"
    fi
    echo -en "\033[0m"
done
