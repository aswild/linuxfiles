#! /bin/zsh

if [[ -e /cygdrive/c/Program\ Files\ \(x86\)/Vim/vim74/gvim.exe ]]; then
    export WINDOWS_HOME='C:\Users\'${HOME##*/}
    function gvim()
    {
        for i in "$@"; do
            HOME=$WINDOWS_HOME cygstart '/cygdrive/c/Program Files (x86)/Vim/vim74/gvim.exe' --remote-tab-silent \"$i\"
        done
    }
fi
