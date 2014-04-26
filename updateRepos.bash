#!/bin/bash

# Ignore repos (grep regex)
declare -a ignoreList=('webgoat' 'django$' 'practice' 'linux' 'updf' 'wordament' 'rss-fixer' 'infa719' 'openssl' 'jhbuild')

onIgnoreList () 
{
    for regex in "${ignoreList[@]}"; do
        echo "$1" | grep "$regex" > /dev/null && return 0
    done
    return 1
}

if [[ $@ =~ [pP] ]]; then
    echo "Push enabled"
else
    echo "Push disabled (rerun with -p|--push to enable)"
fi

for file in $(find . -maxdepth 1 -type d)
do
    echo -en "\033[0;34mUpdating ${file}: \033[0m"
    if [ -d "${file}/.git" ]; then
        if onIgnoreList "${file}"; then
            echo -e "\033[1;33mRepo on ignore list: ${file}\033[0m"
        else
            oldDir=$(pwd)
            cd $file
            if [[ $@ =~ [pP] ]]; then
                git pull -r && git push
            else
                git pull -r
            fi
            cd $oldDir
        fi
    else
        echo -e "\033[0;31mNo Git repo in this folder\033[0m"
    fi
    echo -en "\033[0m"
done
