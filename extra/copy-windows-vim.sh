#!/bin/bash
# Helper script to copy vim config from linuxfiles into the Windows
# user directory for Windows gvim. Split into a separate script because the
# cygwin/wsl detection logic got messy to include inline in the Makefile

if [[ -d /cygdrive ]] && which cygpath &>/dev/null; then
    userdir="$(cygpath -p "$USERPROFILE")"
elif which wslvar &>/dev/null && which wslpath &>/dev/null; then
    userdir="$(wslpath "$(wslvar USERPROFILE)")"
else
    cat >&2 <<EOF
Error: unable to detect cygwin or WSL environment
If using WSL2, make sure wslpath and wslvar are available,
which are part of the 'wslu' package on ubuntu
EOF
    exit 1
fi

if ! which rsync &>/dev/null; then
    echo >&2 "Error: rsync is required"
    exit 1
fi

set -xe
rsync -rLtv --delete vim/ "$userdir/vimfiles"
cp -vf vimrc "$userdir/_vimrc"
