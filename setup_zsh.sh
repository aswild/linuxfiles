#! /bin/bash

ln -s ${PWD}/.zshrc $HOME/.zshrc
ln -s ${PWD}/zshrc_extra $HOME/zshrc_extra

# install oh my zsh
git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
