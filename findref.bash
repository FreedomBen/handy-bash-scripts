#!/bin/bash

DEBUG_MODE=0

# Uncomment the next line to turn on debug output
# DEBUG_MODE=1

TEMP_FILE=$(mktemp)
ABS_PATH_COMMAND="realpath"
IN_GIT_REPO=0

color_light_blue='\033[1;34m'
color_restore='\033[0m'

cur_millis_since_epoch ()
{
    echo $(date +%3N)
}

cur_secs_since_epoch ()
{
    echo $(date +%s)
}

cur_secs_millis_since_epoch ()
{
    echo $(date +%s%3N)
}

START_DEBUG_SECS="$(cur_secs_since_epoch)"

DEBUG ()
{
    if (( $DEBUG_MODE )); then
        echo -e "${color_light_blue}[*] $(( $(cur_secs_since_epoch) - $START_DEBUG_SECS)).$(cur_millis_since_epoch) - DEBUG: $1${color_restore}"
    fi
}

print_usage () 
{
    echo "Usage: findref [-f|--fast (skip git ignore list)] \"what text (RegEx) to look for\" \"[starting location (root dir)]\" \"[filenames to check (must match pattern)]\"";
}


if [ -z "$1" ]; then
    print_usage
    exit;
fi


# Need an absolute path - prefer realpath to readlink if we have it installed
if ! $(which realpath > /dev/null 2>&1); then
    ABS_PATH_COMMAND="readlink -f"
fi


# skip this if given --fast or -f
if [ -n "$3" ]; then
    DEBUG "Skipping git ignore check because we have filename specified ($3)"
elif [[ ! $@ =~ -f ]]; then
    DEBUG "Checking if we're in a git repo"
    # Determine if we are inside of a Git repo so we can consider the .gitignore file
    prevDir="$(pwd)"

    while true; do
        if [ -d ".git" ]; then
            IN_GIT_REPO=1
            break
        fi

        if [ "$(pwd)" = "/" ]; then
            break;
        fi

        cd ..
    done

    cd $prevDir

    if (( DEBUG_MODE )); then
        if (( IN_GIT_REPO )); then
            DEBUG "In Git repo"
        else
            DEBUG "Not in a Git repo"
        fi
    fi
else
    # need to shift away the --fast or -f
    DEBUG "Fast mode turned on, not checking for git repo"
    shift
fi


# where needs to have an absolute path to properly work with our git ignore list
if [ -z "$2" ] || [ ! -e "$2" ]; then
    where="$(pwd)";
else
    # prefer realpath if installed, otherwise use readlink to get absolute path
    where="$(eval $ABS_PATH_COMMAND $2)"
fi

DEBUG "Determined to search from $where"

if [ -z "$1" ]; then
    print_usage
    exit;
else
    what=$(echo "$1" | sed 's/ /\\s/g');
fi

DEBUG "Determined to search for lines matching $what"

if [ -z "$3" ]; then
    filename="";
else
    filename='-iname "$3"';
fi;

DEBUG "Determined to search filenames matching $filename"

DEBUG "Populating the TEMP_FILE $TEMP_FILE with filenames to search"
if (( $IN_GIT_REPO )); then
    DEBUG "In Git repo, so using git's list of files"
    for i in $(git ls-files --exclude-standard); do
        [ -f "$i" ] && echo "$i" >> $TEMP_FILE
    done 
    for i in $(git ls-files --others --exclude-standard); do
        [ -f "$i" ] && echo "$i" >> $TEMP_FILE
    done 
else
    DEBUG "Not in git repo, finding all filenames matching pattern $filename"
    eval find "$where" -type f "$filename" > $TEMP_FILE;
fi

DEBUG "Done populating the TEMP_FILE"

numlines=$(cat $TEMP_FILE | wc -l);
DEBUG "Grepping $numlines files"

for ((i=1; ((1)); i+=1000 ))
do
    if (( numlines > 1000 )); then
        topBoundary=1000;
    else
        topBoundary=numlines;
    fi;
    sed -n $i,$(( i + topBoundary ))p $TEMP_FILE | sed 's/ /\\ /g' | sed "s/'//g" | xargs grep --color --binary-files=without-match --directories=skip --devices=skip --line-number $what;
    numlines=$(( numlines - topBoundary ));
    if (( numlines <= 0 )); then
        break;
    fi;
done;

DEBUG "Done grepping the files"


# clean up the temp files if they exist
if [ -f "$TEMP_FILE" ]; then
    DEBUG "Deleting TEMP_FILE $TEMP_FILE"
    rm -f "$TEMP_FILE";
fi

DEBUG "All done!"

