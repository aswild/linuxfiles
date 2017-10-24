#!/bin/bash

#
# commit_submodules.sh
# Script to automatically commit submodule updates
#

set -e

# make sure we're in a git repo and cd to the top
git status >/dev/null
topdir=$(git rev-parse --show-toplevel 2>/dev/null)
[[ -d $topdir ]] && cd $topdir

# unstage changes so we don't accidentally commit other stuff
git reset HEAD .

# cache the output of git submodule status because it forks a bunch and is sloooowwww on cygwin
subs_status="$(git submodule status)"
subs_status_cached="$(git submodule status --cached)"

subs_dirty="$(awk '/^+/ {print $2}' <<<"$subs_status")"
[[ -z $subs_dirty ]] && exit 0

# Generate commit message
stage_changes()
{
    echo 'Update submodules'
    for sub in $subs_dirty; do
        oldrev="$(awk '/ '"${sub//\//\\/}"' /{sub(/^+/, "", $1); print $1}' <<<"$subs_status_cached")"
        oldrev="${oldrev#+}"
        newrev="$(awk '/ '"${sub//\//\\/}"' /{sub(/^+/, "", $1); print $1}' <<<"$subs_status")"
        newrev="${newrev#+}"

        echo -e "\n * $sub"
        git -C "$sub" log --pretty='   * %h %s' $oldrev..$newrev
        git add "$sub"
    done
}

commitmsg="$(stage_changes)"
git commit -F - <<<"$commitmsg"
git log -1
