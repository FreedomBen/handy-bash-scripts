#!/bin/bash

for file in $(find . -maxdepth 1 -type d)
do
    echo -en "\033[0;34mUpdating ${file}: \033[0m"
    if [ -d ${file}/.git ]; then
        echo -e "\033[0;34mPlease enter credentials if requested\033[0m"
        oldDir=$(pwd)
        cd $file
        git pull -r
        cd $oldDir
    else
        echo -e "\033[0;31mNo Git repo in this folder\033[0m"
    fi
    echo -en "\033[0m"
done
