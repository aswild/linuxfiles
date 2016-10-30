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

subs_dirty=$(git submodule status | awk '/^+/ {print $2}')
[[ -z $subs_dirty ]] && exit 0

subs_list=()
for sub in $subs_dirty; do
    echo "Commiting submodule update: $sub"
    git add $sub
    subs_list+=($sub)
done

# take care of singular/plural
if [[ ${#subs_list[@]} == 1 ]]; then
    subs_word=submodule
else
    subs_word=submodules
fi
subs_str=$(IFS=, ; echo "${subs_list[*]}")
subs_str=${subs_str//,/, }

commit_msg="Update $subs_word: $subs_str"
git commit -m "$commit_msg"
