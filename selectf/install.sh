#!/bin/bash
#######################################################################
# install.sh
# Installer to create multi-call symlinks for selectf.sh
#
# Copyright (c) 2019 Allen Wild
# SPDX-License-Identifier: MIT
#######################################################################

DEFAULT_TARGET="$(readlink -f "$(dirname "$0")/selectf.sh")"

USAGE="Usage: $0 [-h|--help] [-f|--force] DESTDIR [TARGET]
Options:
    -h --help   Show this help text
    -f --force  Overwrite existing links

Arguments:
    DESTDIR     Directory to install links in
    TARGET      Target script of the links (default '$DEFAULT_TARGET')
"
usage() {
    echo >&2 "$USAGE"
    if [[ -n "$1" ]]; then
        exit $1
    fi
}

force=''

while (( $# )); do
    case "$1" in
        -h|--help)
            usage 0
            ;;
        -f|--force)
            force='-f'
            ;;
        -*)
            echo "Invalid option '$1'"
            usage 1
            ;;
        *)
            break
            ;;
    esac
    shift
done

if [[ -z "$1" ]]; then
    echo "Error: no destdir"
    usage 1
fi
DESTDIR="$1"

if [[ -n "$2" ]]; then
    TARGET="$2"
else
    TARGET="$DEFAULT_TARGET"
fi

mkdir -p "$DESTDIR" || exit 1
ln -svT $force "$TARGET" "$DESTDIR/selectf"

for name in {,g}vimf{,r}{,i}{,a}; do
    ln -svT $force selectf "$DESTDIR/$name"
done
