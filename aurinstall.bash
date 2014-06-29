#!/bin/bash -e

usage ()
{
    echo "$0 {URL or path to tarball}"
    echo "    Ex:  $0 ~/aur/tarballs/ttf-ms-fonts.tar.gz"
    echo "    Ex:  $0 https://aur.archlinux.org/packages/tt/ttf-ms-fonts/ttf-ms-fonts.tar.gz"
}

if [ "$(id -u)" = "0" ]; then
    echo "I should not be run as root!"
    exit 1
fi


if [ -z "$1" ]; then
    usage
    exit 1
fi

if [[ "$@" =~ -h ]]; then
    usage
    exit 0
fi


if [ ! -f "$1" ]; then
    if ! [[ "$1" =~ ^http ]]; then
        echo "Expected URL to begin with http.  Try to open \"$1\" with curl anyway? (Y/N): "
        read CONFIRM

        if ! [[ "$CONFIRM" =~ [Yy] ]]; then
            exit 1
        fi
    fi
fi

AUR_DIR="$HOME/aur"
AUR_BUILD_DIR="$AUR_DIR/build"
AUR_TARBALLS_DIR="$AUR_DIR/tarballs"
AUR_ARCHIVE_DIR="/var/cache/aur"

mkdir -p "$AUR_TARBALLS_DIR"

prevdir=$(pwd)

use_cower=0
if [ -f "$1" ]; then
    [ "$1" -ef "$AUR_TARBALLS_DIR/$(basename $1)" ] || cp "$1" "$AUR_TARBALLS_DIR/"
elif [[ "$1" =~ ^http ]]; then
    cd "$AUR_TARBALLS_DIR"
    curl -O "$1"
else
    use_cower=1
fi

if (( $use_cower )); then
    if $(which cower > /dev/null 2>&1); then
        cd $AUR_BUILD_DIR
        cower -d -d "$1"
        output_dir="$1"
    else
        echo "cower is not installed, and you did not pass a tarball or URL. Cannot install package"
        exit 1
    fi
else
    tarball="$(basename $1)"
    # output_dir="$(echo $tarball | sed -e 's/\.t.*//g')" # To support .tgz files
    output_dir="$(echo $tarball | sed -e 's/\.tar.*//g')"
    cd "$AUR_BUILD_DIR"
    tar xf "$AUR_TARBALLS_DIR/$tarball"
fi

cd "$output_dir"
makepkg --clean --syncdeps --needed --install
sudo cp *.tar.* "$AUR_ARCHIVE_DIR"

