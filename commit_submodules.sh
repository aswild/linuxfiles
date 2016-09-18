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

subs_dirty=$(git submodule status | awk '/^+/ {print $2}')
[[ -z $subs_dirty ]] && exit 0

# unstage changes so we don't accidentally commit other stuff
git reset HEAD .

subs_list=""
for sub in $subs_dirty; do
    echo "Commiting submodule update: $sub"
    git add $sub
    subs_list+="$sub, "
done
subs_list=$(echo "$subs_list" | sed 's/, $//')

# take care of singular/plural
subs_num=$(echo "$subs_list" | wc -l)
if [[ $subs_num == 1 ]]; then
    subs_word=submodule
else
    subs_word=submodules
fi

commit_msg="Update $subs_word: $subs_list"
git commit -m "$commit_msg"
