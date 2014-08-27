#!/bin/bash

# Ignore repos (grep regex)
# these repos will be ignored altogether
declare -a ignoreList=('canvas' 'ubuntu' 'webgoat' 'django$' 'practice' 'linux$' 'linux\-stable$' 'wordament' 'infa719' 'jhbuild')

# this list the repos will be pulled but never pushed
declare -a pushIgnoreList=('sample' 'cower' 'updf' 'rtl8188ce' 'openssl' 'doxygen' 'YouCompleteMe' 'mkinitcpio')

push_enabled=1

# color variables to make it a lot easier to use color
color_restore='\033[0m'
color_black='\033[0;30m'
color_red='\033[0;31m'
color_green='\033[0;32m'
color_brown='\033[0;33m'
color_blue='\033[0;34m'
color_purple='\033[0;35m'
color_cyan='\033[0;36m'
color_light_gray='\033[0;37m'
color_dark_gray='\033[1;30m'
color_light_red='\033[1;31m'
color_light_green='\033[1;32m'
color_yellow='\033[1;33m'
color_light_blue='\033[1;34m'
color_light_purple='\033[1;35m'
color_light_cyan='\033[1;36m'
color_white='\033[1;37m'


onIgnoreList () 
{
    for regex in "${ignoreList[@]}"; do
        echo "$1" | grep "$regex" > /dev/null && return 0
    done
    return 1
}

onPushIgnoreList () 
{
    for regex in "${pushIgnoreList[@]}"; do
        echo "$1" | grep "$regex" > /dev/null && return 0
    done
    return 1
}

hasChanges ()
{
     git status | grep "hanges not staged for commit" > /dev/null
}

hasPushes ()
{
    git status | grep "our branch is ahead of" > /dev/null
}

if [[ $@ =~ [pP] ]]; then
    echo "Push disabled"
    push_enabled=0
else
    echo "Push enabled (rerun with -p|--push to disable)"
fi

for file in $(find . -maxdepth 1 -type d)
do
    echo -en "${color_blue}Updating ${file}: ${color_restore}"
    if [ -d "${file}/.git" ]; then
        if onIgnoreList "${file}"; then
            echo -e "${color_purple}Repo on ignore list: ${file}${color_restore}"
        else
            oldDir=$(pwd)
            cd $file

            dopop=0
            if hasChanges; then
                git stash save "saved-by-update-files-script" > /dev/null && dopop=1
            fi

            if (( push_enabled )) ; then
                if ! onPushIgnoreList "${file}"; then
                    if hasPushes; then
                        git pull --rebase && git push
                    else
                        echo -en "${color_green}Nothing to push: ${file}: ${color_restore}"
                        git pull --rebase
                    fi
                else
                    echo -en "${color_light_cyan}Repo on push ignore list: ${file}: ${color_restore}"
                    git pull --rebase
                fi
            else
                git pull --rebase
            fi

            if (( $dopop )); then
                echo -e "${color_yellow}You have uncommitted changes in ${file}${color_restore}"
                git stash pop > /dev/null || echo "${color_red}Oh no! Git pop failed! I hope I didn't lose your changes in ${file}${color_restore}"
            fi

            cd $oldDir
        fi
    else
        echo -e "${color_red}No Git repo in this folder${color_restore}"
    fi
    echo -en "${color_restore}"
done

