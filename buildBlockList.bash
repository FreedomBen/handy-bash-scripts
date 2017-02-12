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
curl -L http://list.iblocklist.com/?list=bt_level1 > bt1.gz
echo "Downloading iBlocklist Level 2..."
curl -L http://list.iblocklist.com/?list=bt_level2 > bt2.gz
echo "Downloading iBlocklist Level 3..."
curl -L http://list.iblocklist.com/?list=bt_level3 > bt3.gz

gunzip -c bt1.gz > $OUT
gunzip -c bt2.gz >> $OUT
gunzip -c bt3.gz >> $OUT
rm bt{1..3}.gz
 
echo "Done."
