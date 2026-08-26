#!/bin/bash

set -xe

if [[ -f ./Microsoft/scripts/gen_modules_vhdx.sh ]]; then
    # Older script. No longer present in the linux-msft-wsl-6.18.40.1 tag, but required for older
    # WSL versions. May need to check out gen_modules_vhdx.sh from an older kernel revision if
    # building a new kernel but WSL hasn't been updated on the host.
    make all
    rm -rf modules modules-wsl2.vhdx
    make INSTALL_MOD_PATH=$PWD/modules modules_install
    sudo ./Microsoft/scripts/gen_modules_vhdx.sh \
        $PWD/modules \
        $(make -s kernelrelease) \
        modules-wsl2.vhdx
elif [[ -f ./Microsoft/scripts/gen_artifacts_vhdx.sh ]]; then
    # Newer script that also bundles perf and the kernel headers. Requires WSL version 2.9.8 to
    # mount this vhdx format[1] (which is a pre-release at the time of writing). The changes to
    # mount the headers and perf from this vhdx layout are still not yet merged[2].
    # [1] https://github.com/microsoft/WSL/commit/9540481e9d276a3a732b22057c872f9bc6d41a0c
    # [2] https://github.com/microsoft/WSL/pull/41400
    make all
    make -C tools/perf WERROR=0 perf
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
