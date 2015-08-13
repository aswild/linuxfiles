#! /bin/bash

# Setup for Allen's linux files.
# Everything in this repo is assumed to belong in the ${HOME} directory
# and is simlinked
#

EXCLUDE_FILES="setup.sh .gitignore .git bin .config"

contains() {
	local e
	for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
	  return 1
}

#create symlinks for config files
for f in $(ls -A); do
	# ignore excluded files
	contains $f $EXCLUDE_FILES && continue

	# create symlinks so everything stays in this git repo folder
	[[ -e $HOME/$f ]] && [[ ! -e $HOME/${f}.bak ]] && mv $HOME/$f $HOME/${f}.bak
	ln -s ${PWD}/$f $HOME/$f
done

# copy bin files
mkdir -p $HOME/bin
cp -rt $HOME/bin bin/*

# copy .config files
mkdir -p $HOME/.config
cp -rt $HOME/.config .config/*

echo '[[ -e ~/bashrc_extra ]] && . ~/bashrc_extra' >> ~/.bashrc

if [[ $1 == zsh ]]; then
    ln -s ${PWD}/.zshrc $HOME/.zshrc
    ln -s ${PWD}/zshrc_extra $HOME/zshrc_extra

    # install oh my zsh
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi
