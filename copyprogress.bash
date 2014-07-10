#!/bin/bash

TEMP_FILE=$(mktemp)

set_baseline ()
{
    du -hs * | sort -h > $TEMP_FILE
}

check_progress ()
{
    res="$(diff -Naur $TEMP_FILE <(du -hs * | sort -h))"
    if [ -z "$res" ]; then
        echo "No change in status"
    else
        echo "$res" | grep "^[\+\-]" | tail -n +3
    fi
}

set_baseline

while true; do
    for i in {1..10}; do
        clear
        check_progress
        sleep 2
    done
done


