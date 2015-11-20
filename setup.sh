#! /bin/bash

# Setup for Allen's linux files.

SYMLINK_FILES=".vim .dircolors myshrc .tmux.conf .vimrc .zshrc .gitconfig_common"

contains() {
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
      return 1
}

#create symlinks for config files
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
cp -rvt $HOME/bin bin/*

# copy .config files
echo "copying files from .config/"
mkdir -p $HOME/.config
cp -rvt $HOME/.config .config/*

echo 'sourcing myshrc in .bashrc'
echo '[[ -e ~/myshrc ]] && . ~/myshrc' >> ~/.bashrc
echo '[[ -e ~/myshrc_local ]] && . ~/myshrc_local' >> ~/.bashrc

echo 'including .gitconfig_common'
echo -e "\n[include]\n    file = ~/.gitconfig_common" >>~/.gitconfig

read -p 'Install oh my zsh? (y/n) ' i_zsh
[[ ${i_zsh:0:1} =~ [yY] ]] && git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

read -p 'Download tmux 2.0? (y/n)' i_tmux
[[ ${i_tmux:0:1} =~ [yY] ]] && (mkdir -p ~/packages; wget -O ~/packages/tmux-2.0.tar.gz \
    https://github.com/tmux/tmux/releases/download/2.0/tmux-2.0.tar.gz')
