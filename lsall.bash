#!/bin/bash

# does an ls on all directories in the current dir recursively
if [ -z "$1" ]; then
    dir="."
else 
    dir="$1"
fi

for i in $(find . -type d | sed 's/ /12345/g' | sed 's/.*/"&"/g')
do 
    echo $i | sed 's/12345/ /g' | xargs ls 
done
                                                                    
