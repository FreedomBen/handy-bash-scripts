#!/bin/bash

BACKUP_DIR="$HOME/.backups"
declare -a INPUT_FILE
OUTPUT_FILE=""

echoerr () 
{
    echo "$@" 1>&2
}

die ()
{
    echo "Error: $1"
    exit
}

usage () 
{
    echo "Backup a file or directory (useful before changing system config files)"
    echo "$0 [-h|--help] file-or-directory [-o|--output output-file]"
}

backupRegFile () 
{
    outfile="${BACKUP_DIR}/$(basename $1).bk"

    if [ -n "$OUTPUT_FILE" ]; then
        outfile="$OUTPUT_FILE"
    fi

    confirm="y"

    if [ -e $outfile ]; then
        read -p "Output file $outfile exists.  Overwrite? (Y/N): " confirm
    fi

    if [[ $confirm =~ [yY] ]]; then
        cp "$1" "$outfile"
    fi

    if [ -f "$outfile" ]; then
        if [[ $confirm =~ [^nN] ]]; then
            echo "Successfully backed up $1 to $outfile"
        else
            echo "Did not overwrite $outfile"
        fi
    elif [[ $confirm =~ [^nN] ]]; then
        echoerr "Problem copying $1 to $outfile"
    fi
}

backupDir ()
{
    outfile="${BACKUP_DIR}/$(basename $1).bk.tar.gz"

    if [ -n "$OUTPUT_FILE" ]; then
        cp "$1" "$OUTPUT_FILE"
        outfile="$OUTPUT_FILE"
    else
        confirm="y"

        if [ -e $outfile ]; then
            read -p "Output file $outfile exists.  Overwrite? (Y/N): " confirm
        fi

        if [[ $confirm =~ [yY] ]]; then
            tar -czf "$outfile" "$1" > /dev/null
        fi
    fi

    if [ -f "$outfile" ]; then
        if [[ $confirm =~ [^nN] ]]; then
            echo "Successfully backed up $1 to $outfile"
        else
            echo "Did not overwrite $outfile"
        fi
    elif [[ $confirm =~ [^nN] ]]; then
        echoerr "Problem copying $1 to $outfile"
    fi
}

backupFile () 
{
    if [ -f "$1" ]; then
        backupRegFile "$1"
    elif [ -d "$1" ]; then
        backupDir "$1"
    else
        echoerr "$1 is an Unsupported file type - must be a directory or a regular file (not a symlink/socket/pipe/device/etc.)"
        echoerr "$1 was not backup up"
    fi
}

# No args
if [ "$#" = "0" ]; then
    usage
    exit
fi

# process args
prevArgWasOutput=0
while (( "$#" )); do
    if [[ $1 =~ -h ]]; then
        usage
        exit
    elif [[ $1 =~ -o ]]; then
        OUTPUT_FILE="$2"
        prevArgWasOutput=1
    else
        if [ -e "$1" ]; then
            # Append file to end of INPUT_FILE array
            INPUT_FILE[${#INPUT_FILE[@]}]="$1"
        elif [ "$prevArgWasOutput" -ne 1 ]; then
            die "Cannot back-up non-existent file \"$1\""
        fi
        prevArgWasOutput=0
    fi

    shift
done


if (( ${#INPUT_FILE[@]} > 1 )) && [ -n "$OUTPUT_FILE" ]; then
    die "Cannot specify output-file with two or more input files. Ambiguous output"
fi

if [ -z "$OUTPUT_FILE" ]; then
    mkdir -p "$BACKUP_DIR"
fi

for i in "${INPUT_FILE[@]}"; do
    backupFile "$i"
done

