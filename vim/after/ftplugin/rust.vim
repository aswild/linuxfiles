" Don't redirect gq formatting through rustfmt, it breaks badly when trying to
" just wrap comments, which is what I actually use gq for.
"
" (this script is sourced after RUNTIME/ftplugin/rust.vim)
set formatprg=
