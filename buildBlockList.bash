#!/bin/bash
 
if [ -z "$1" ]
then
    OUT="$HOME/.config/transmission/blocklists/blocklist.txt"
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
