#! /bin/bash

# Setup for Allen's linux files.
# Everything in this repo is assumed to belong in the ${HOME} directory
# and is simlinked
#

EXCLUDE_FILES="setup.sh .gitignore .git"

contains() {
	local e
	for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
	  return 1
}

for f in $(ls -A); do
	# ignore excluded files
	contains $f $EXCLUDE_FILES && continue

	# create symlinks so everything stays in this git repo folder
	[[ -e $HOME/$f ]] && mv $HOME/$f $HOME/${f}.bak
	ln -s $HOME/$f $f
done


