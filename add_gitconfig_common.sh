#! /bin/bash

OPWD=$PWD
cd ~

#echo "symlinking .gitconfig_common"
#ln -s linuxfiles/.gitconfig_common ~/.gitconfig_common
#
#echo -e "\n[include]\n    file = ~/.gitconfig_common" >> ~/.gitconfig

echo "Press enter to delete this script, or ^C to abort"
read foo

cd $OPWD
rm -f add_gitconfig_common.sh
