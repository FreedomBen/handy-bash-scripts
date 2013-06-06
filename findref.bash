#!/bin/bash

TEMP_FILE=$HOME/.findreftempfile

# if second arg is present use that as starting location, else use current path
 if [ -z "$2" ]; then
     where='.'
 else 
     where=$2
 fi

 # if first are is not present, print usage
 if [ -z "$1" ]; then
     echo "Usage: findref \"what text (RegEx) to look for\" \"[starting location (root dir)]\" \"[filenames to check (must match pattern)]\""
     exit
 else
     what=$(echo $1 | sed 's/ /\\s/g') # convert spaces to regex space
 fi

 # if third arg is not present, don't restrict the file name
 if [ -z "$3" ]; then
     filename=""
 else
     filename='-iname "$3"'
 fi

 # Original grep command - preserved for historical value
 # grep --color --line-number $what $(echo $(eval find $where -type f $filename))

 # Do this complexity to avoid the too many args problem with grep
 eval find $where -type f $filename > $TEMP_FILE
 numlines=$(cat ~/.findreftempfile | wc -l)
 for (( i=1; ((1)); i+=1000 ))
 do
     if (( numlines > 999 )); then
         topBoundary=999
     else
         topBoundary=numlines
     fi
     # read 1000 lines at a time, then escape the spaces in the path names, then feed to grep
     sed -n $i,$(( i + topBoundary ))p $TEMP_FILE | sed 's/ /\\ /g' | xargs grep --color --line-number $what
     numlines=$(( numlines - topBoundary )) 
     if (( numlines <= 0 )); then
         break;
     fi  
 done

 # if temp file exists, delete it
 if [[ -e $TEMP_FILE ]]; then
     rm -f $TEMP_FILE
 fi

