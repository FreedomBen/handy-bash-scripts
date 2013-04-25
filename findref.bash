#!/bin/bash

 TEMP_FILE=$HOME/.findreftempfile

 # if third arg is present use that as starting location, else use current path
 if [ -z "$3" ]; then
     where='.'
 else 
     where=$3
 fi

 # if first are is not present, print usage
 if [ -z "$1" ]; then
     echo "Usage: findref \"what text (RegEx) to look for\" \"[filenames to check (must match pattern)]\" \"[starting location (root dir)]\""
     exit
 else
     what=$(echo $1 | sed 's/ /\\s/g') # convert spaces to regex space
 fi

 # if second arg is not present, don't restrict the file name
 if [ -z "$2" ]; then
     filename=""
 else
     filename="-iname '$2'"
 fi

 # Original grep command - preserved for historical value
 # grep --color --line-number $what $(echo $(eval find $where -type f $filename))

 # Do this complexity to avoid the too many args problem with grep
 find $where -type f $filename > $TEMP_FILE
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

