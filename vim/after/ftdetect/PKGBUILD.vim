" The PKGBUILD syntax from pacman-contrib is ugly, so fall back to sh
" The function call is from the builtin vim81/filetype.vim to enable bash
" stuff rather than whatever autodetection logic :setf has.
"
" In order to actually override /usr/share/vim/vimfiles/ftdetect/PKGBUILD.vim
" we have to clear the autocommands first, and this file needs to be in the
" 'after' folder so that it gets sourced after the pacman-contrib file
" when filetype.vim runs :runtime! ftdetect/*.vim
au! BufNewFile,BufRead PKGBUILD
au BufNewFile,BufRead PKGBUILD call dist#ft#SetFileTypeSH("bash")
