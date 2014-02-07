#!/bin/bash

DEFAULT_DIR="$HOME/.config/transmission/blocklists/"
DEFAULT_FILE="blocklist.txt"
 
if [ -z "$1" ]
then
    OUT="${DEFAULT_DIR}${DEFAULT_FILE}"
    if [ ! -d "$DEFAULT_DIR" ]; then
        mkdir -p "$DEFAULT_DIR"
    fi
else
    OUT="$1"
fi

echo "Creating list file at $OUT"
touch $OUT

echo "Downloading iBlocklist Level 1..."
curl -L --silent http://list.iblocklist.com/?list=bt_level1 | gunzip -c > $OUT
echo "Downloading iBlocklist Level 2..."
curl -L --silent http://list.iblocklist.com/?list=bt_level2 | gunzip -c >> $OUT
echo "Downloading iBlocklist Level 3..."
curl -L --silent http://list.iblocklist.com/?list=bt_level3 | gunzip -c >> $OUT
 
echo "Done."
