#! /bin/bash

# Setup for Allen's linux files.

#EXCLUDE_FILES="setup.sh .gitignore .git bin .config"
SYMLINK_FILES=".vim .dircolors myshrc .tmux.conf .vimrc .zshrc"

contains() {
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
      return 1
}

#create symlinks for config files
#for f in $(ls -A); do
#   # ignore excluded files
#   contains $f $EXCLUDE_FILES && continue
for f in $SYMLINK_FILES; do
    # create symlinks so everything stays in this git repo folder
    if [[ ( -e $HOME/$f ) && ( ! -e $HOME/${f}.bak ) ]]; then
        echo "Backing up: $HOME/$f"
        mv $HOME/$f $HOME/${f}.bak
    fi
    echo "Symlink $f"
    ln -s ${PWD}/$f $HOME/$f
done

# copy bin files
echo "copying files from bin/"
mkdir -p $HOME/bin
#cp -rvt $HOME/bin bin/*
for f in $(ls bin); do 
    if [[ ( -e $HOME/bin/$f ) && ( ! -e $HOME/bin/${f}.bak ) ]]; then
        echo "Backing up: $HOME/bin/$f"
        mv $HOME/bin/$f $HOME/bin/${f}.bak
    fi
    echo "Symlink $f"
    ln -s ${PWD}/bin/$f $HOME/bin/$f
done

# copy .config files
echo "copying files from .config/"
mkdir -p $HOME/.config
#cp -rvt $HOME/.config .config/*
for f in $(ls .config); do 
    if [[ ( -e $HOME/.config/$f ) && ( ! -e $HOME/.config/${f}.bak ) ]]; then
        echo "Backing up: $HOME/.config/$f"
        mv $HOME/.config/$f $HOME/.config/${f}.bak
    fi
    echo "Symlink $f"
    ln -s ${PWD}/.config/$f $HOME/.config/$f
done

echo 'sourcing myshrc in .bashrc'
echo '[[ -e ~/myshrc ]] && . ~/myshrc' >> ~/.bashrc
echo '[[ -e ~/myshrc_local ]] && . ~/myshrc_local' >> ~/.bashrc

read -p 'Install oh my zsh? (y/n) ' i_zsh
[[ ${i_zsh:0:1} =~ [yY] ]] && git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
