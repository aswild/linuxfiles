""""""""""""""""""""""
" Allen's vimrc file
""""""""""""""""""""""

" enable pathogen plugin-loading
execute pathogen#infect()

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup  " do not keep a backup file, use versions instead
else
  "set backup   " keep a backup file
  set nobackup
endif
set history=50  " keep 50 lines of command line history
set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set incsearch   " do incremental searching
set number
"set noexpandtab
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set showmode
set showcmd
"set makeprg=nmake

" from stevelosh
set encoding=utf-8
set scrolloff=3
"set hidden
set wildmenu
set wildmode=list:longest
set visualbell
"set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
"set relativenumber
"set undofile

let $REL=0
function! ToggleNumber()
    if $REL
        set number
        let $REL=0
    else
        set relativenumber
        let $REL=1
    endif
endfunction
nmap <silent><F8> :call ToggleNumber()<CR>

let mapleader = ","

"nnoremap / /\v
"vnoremap / /\v
"cnoremap %s/ %s/\v
"cnoremap s/ s/\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
set foldmethod=marker
nnoremap <silent><leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

set wrap
set formatoptions=qrn1
"set colorcolumn=85

nnoremap j gj
nnoremap k gk

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
nnoremap ; :
vnoremap ; :
inoremap jj <ESC>

"window splits
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
"nnoremap <C-j> <C-w>j
"nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


" Ctrl-j/k inserts blank line below/above, and Alt-j/k deletes.
nnoremap <silent><A-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><A-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
"let &guioptions = substitute(&guioptions, "t", "", "g")
set go-=T

" Don't use Ex mode, use Q for formatting
map Q gq

" ALLEN KEY MAPPINGS
nmap <F5> :wa \| !python %<CR>
imap <F5> <ESC>:wa \| !python %<CR>
nmap <F6> :wa \| :make<CR>
nmap <F12> :wa <CR>
imap <F12> <ESC>:wa<CR>
imap <C-BS> <C-W>
imap [127;5u <C-W>
imap  <C-W>
nmap <HOME> ^
imap <HOME> <ESC>^i
imap <C-V> <ESC>"+gpa
nmap <C-V> "+gP
vmap <C-C> "+y`>
vmap <C-X> "+x
vmap y y`>
noremap <silent> <F3> :set nohlsearch!<CR>
"noremap / :set hlsearch<CR>/
inoremap {<CR>  {<CR>}<Esc>O
"nmap s c$
nmap <C-A> ggVG
"Alt-/ searches for whatever's on the clipboard
nmap ¯ /<C-R>+
nmap J <C-E>
nmap K <C-Y>
vmap / y/<C-R>0
"imap <C-S-V> <C-V>
vmap <silent> <C-R> V0<C-V>I#<ESC>
vmap <silent> <C-T> :s/\v^(\s*)#(.*)$/\1\2<CR>:noh<CR>
nmap <F10> :let @*=@+<CR>
nmap <F9> :let @+=@*<CR>
nmap <leader>p dd"0P
nmap <leader>P D"0p
nmap <leader>e de"0P
nmap \ "
nnoremap n nzz
nnoremap N Nzz
nmap <C-Insert> :set paste! \| set paste?<CR>
nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>
nnoremap <silent># m`I#<ESC>``l
nnoremap <silent><leader># :s/\v(\s*)#(.*)$/\1\2/<cr>:noh<cr>
vmap <silent># V^<C-V>I#<ESC>
vmap <silent><leader># :s/\v(\s*)#(.*)$/\1\2/<cr>:noh<cr>
nnoremap <silent><leader>/ m`^i//<ESC>``l
nnoremap <silent><leader>. :s#\v(\s*)//(.*)$#\1\2#<CR>:noh<CR>
vmap <silent><leader>/ V^<C-V>I//<ESC>
vmap <silent><leader>. :s#\v(\s*)//(.*)$#\1\2#<CR>:noh<CR>
nnoremap <Space> 10j
nnoremap <S-Space> 10k
imap <M-C-F12> _
nmap <M-C> f#llC
imap <C-H> <Esc>i
imap <C-J> <ESC>ja
imap <C-K> <ESC>ka
imap <C-L> <ESC>la
imap <C-S> <ESC>S

" solarized light/dark toggle
call togglebg#map("<F7>")

" ctrlp.vim mappings/settings
nnoremap <C-P> :CtrlP<cr>
"let g:ctrlp_root_markers = ['.repo']
let g:ctrlp_custom_ignore = {'dir': '\v[/]\.(pc|repo|git)$'}
let g:ctrlp_max_files = 500000

let g:airline_theme = 'wombat'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tmuxline#enabled = 0

" tmuxline - don't use weird unicode characters
let g:tmuxline_powerline_separators = 1
let g:tmuxline_status_justify = 'left'
let g:tmuxline_preset = {
      \'a'    : 'S#S',
      \'b'    : 'W#I',
      \'c'    : 'P#P',
      \'win'  : '#I #W',
      \'cwin' : '#I #W',
      \'x'    : '',
      \'y'    : '%l:%M %P',
      \'z'    : '#(whoami)@#H'}


if has("win32")
    nmap <F11> :so ~/_vimrc<CR>
else
    nmap <F11> :so ~/.vimrc<CR>
endif

command! Space set et | retab | set noet
command! Tab set tabstop=3 | retab! | set tabstop=4 | set noet
command! -nargs=1 Wrap set cc=<args> | set tw=<args> | set formatoptions+=t
command! NT NERDTree
command! Trailsp %s/\s\+$//e | noh


" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
"if has("gui_running")
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif
if has("gui_running")
    set background=light
    colorscheme solarized
    set cursorline
    set tabpagemax=100
    if has("win32")
        au GUIEnter * simalt ~x " maximize on startup
        set guifont=Noto_Mono_for_Powerline:h10:cANSI
    else
        " default GUI font on Linux
        set guifont=Noto\ Mono\ for\ Powerline\ 10
    endif
else
    colorscheme bluegreen
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

  " start NERDTree if opening a directory
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
else

  set autoindent " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

"maximize gvim, use for linux
if has("gui_running")
    "set lines=40 columns=120
endif

" allow for local overrides
if filereadable(expand("~/.vimrc_local"))
    source ~/.vimrc_local
endif
