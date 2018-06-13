" Vim filetype plugin file
" Language:             Automake
" Previous Maintainer:  Nikolai Weibull <now@bitwi.se>
" Latest Revision:      2008-07-09

if exists("b:did_ftplugin")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

runtime! ftplugin/make.vim ftplugin/make_*.vim ftplugin/make/*.vim

let &cpo = s:cpo_save
unlet s:cpo_save

" WILD - wish I had a way to hard-tab on rules only
" and not variable value lists
setlocal expandtab softtabstop=4
