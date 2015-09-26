#! /bin/zsh

if [[ -e /cygdrive/c/Program\ Files\ \(x86\)/Vim/vim74/gvim.exe ]]; then
    function gvim()
    {
        for i in "$@"; do
            HOME='C:\Users\Allen' cygstart '/cygdrive/c/Program Files (x86)/Vim/vim74/gvim.exe' --remote-tab-silent \"$i\"
        done
    }
fi
