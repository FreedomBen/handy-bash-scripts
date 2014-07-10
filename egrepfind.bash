#!/bin/bash

# A shortcut to using find with egrep type regular expressions

usage ()
{
    echo "$0 start/path regex [action]"
    echo ""
    echo 'An example of the type of search we use:'
    echo '    find . -regextype egrep -regex ".*/(Upgrader\.cxx|PathReservationManager\.h)"'
}

if [ -z "$1" -o -z "$2" ]; then
    usage
    exit 1
fi

find "$1" -regextype egrep -regex \'"$2"\' "$3"
