#!/bin/bash

set -xe

if [[ -f ./Microsoft/scripts/gen_modules_vhdx.sh ]]; then
    # Older script. No longer present in the linux-msft-wsl-6.18.40.1 tag, but we still need this
    # for WSL at least 2.9.4 which expects the modules to be the vhdx directly.
    make all
    rm -rf modules modules-wsl2.vhdx
    make INSTALL_MOD_PATH=$PWD/modules modules_install
    sudo ./Microsoft/scripts/gen_modules_vhdx.sh \
        $PWD/modules \
        $(make -s kernelrelease) \
        modules-wsl2.vhdx
elif [[ -f ./Microsoft/scripts/gen_artifacts_vhdx.sh ]]; then
    # Newer script that also bundles perf and the kernel headers. Supposedly newer WSL versions
    # expect this, but at least as of 2.9.4 it doesn't work and I need to get the old script.
    make all
    make -C tools/perf
    rm -rf dist modules-wsl2.vhdx
    make INSTALL_MOD_PATH=$PWD/dist/modules modules_install
    make INSTALL_HDR_PATH=$PWD/dist/headers headers_install
    install -Dm755 tools/perf/perf dist/perf/bin/perf

    ./Microsoft/scripts/gen_artifacts_vhdx.sh \
        $PWD/dist/modules \
        $PWD/dist/headers \
        $PWD/dist/perf \
        $(make -s kernelrelease) \
        modules-wsl2.vhdx
fi
