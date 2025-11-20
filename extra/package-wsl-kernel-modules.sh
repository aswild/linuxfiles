#!/bin/bash

set -xe

if [[ ! -f ./Microsoft/scripts/gen_modules_vhdx.sh ]]; then
    echo "This script must be run from the WSL2 kernel repo"
    exit 1
fi

make all
rm -rf modules modules-wsl2.vhdx
make INSTALL_MOD_PATH=$PWD/modules modules_install
sudo ./Microsoft/scripts/gen_modules_vhdx.sh $PWD/modules $(make -s kernelrelease) modules-wsl2.vhdx
