""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim packages are added to runtimepath after vimrc is processed, so
" I can't call any autoload functions from packages' plugins because
" their autoload directories won't be in runtimepath yet. This is
" different than how Pathogen behaves.
"
" To workaround, this file is used to call autoload functions of my
" plugins from external packages when they're available after vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" solarized light/dark toggle
call togglebg#map("<F7>")

" lighter weight right-hand section (line/column numbers)
let g:airline_section_z = airline#section#create(['linenr', 'maxlinenr', '%3v'])
