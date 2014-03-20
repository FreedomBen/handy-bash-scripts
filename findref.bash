#!/bin/bash

TEMP_FILE=$HOME/.findreftempfile;
TEMP_FILE_GIT=$HOME/.findreftempfileGit;
ABS_PATH_COMMAND="realpath"
IN_GIT_REPO=0
declare -a GIT_IGNORE

# Need an absolute path - prefer realpath to readlink if we have it installed
if ! $(which realpath > /dev/null 2>&1); then
    ABS_PATH_COMMAND="readlink -f"
fi

prevDir="$(pwd)"

# Determine if we are inside of a Git repo so we can consider the .gitignore file
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


if (( $IN_GIT_REPO )); then
    declare -a IGNORED_FILES

    for i in $(git ls-files --ignored --exclude-standard); do
        IGNORED_FILES["${#IGNORED_FILES[@]}"]="$(eval $ABS_PATH_COMMAND $i)"
    done

    # if we want to add untracked files to the list, uncomment this
    # for i in $(git ls-files --exclude-standard --others); do
    #     IGNORED_FILES["${#IGNORED_FILES[@]}"]="$(eval $ABS_PATH_COMMAND $i)"
    # done

    isFileIgnored () 
    {
        for i in "${IGNORED_FILES[@]}"; do
            if [ "$i" = "$1" ]; then
                return 0
            fi
        done

        return 1
    }
fi


# where needs to have an absolute path to properly work with our git ignore list
    if [ -z "$2" ] || [ ! -e "$2" ]; then
    where="$(pwd)";
else
    # prefer realpath if installed, otherwise use readlink to get absolute path
    where="$(eval $ABS_PATH_COMMAND $2)"
fi

if [ -z "$1" ]; then
    echo "Usage: findref \"what text (RegEx) to look for\" \"[starting location (root dir)]\" \"[filenames to check (must match pattern)]\"";
    return;
else
    what=$(echo "$1" | sed 's/ /\\s/g');
fi;

if [ -z "$3" ]; then
    filename="";
else
    filename='-iname "$3"';
fi;


eval find "$where" -type f "$filename" > $TEMP_FILE;

# if filename pattern is empty, and we're in a git repo, honor the git ignore list
if [ -z "$filename" ]; then
    while read line; do
        if ! isFileIgnored "$line"; then
            echo "$line" >> "$TEMP_FILE_GIT"
        fi
    done < $TEMP_FILE

    mv "$TEMP_FILE_GIT" "$TEMP_FILE"
fi

numlines=$(cat $TEMP_FILE | wc -l);

for ((i=1; ((1)); i+=1000 ))
do
    if (( numlines > 1000 )); then
        topBoundary=1000;
    else
        topBoundary=numlines;
    fi;
    sed -n $i,$(( i + topBoundary ))p $TEMP_FILE | sed 's/ /\\ /g' | xargs grep --color --binary-files=without-match --line-number $what;
    numlines=$(( numlines - topBoundary ));
    if (( numlines <= 0 )); then
        break;
    fi;
done;

# clean up the temp files if they exist
if [ -f "$TEMP_FILE" ]; then
    rm -f "$TEMP_FILE";
fi
if [ -f "$TEMP_FILE_GIT" ]; then
    rm -f "$TEMP_FILE_GIT";
fi


