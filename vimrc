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
set modeline

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
set diffopt+=vertical

set wildignore=*.o,*.d,*.pyc

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
nmap <F9> :syn sync fromstart<CR>
nmap <F12> :wa <CR>
imap <F12> <ESC>:wa<CR>
imap <C-BS> <C-W>
imap <C-_> <C-W>
nmap <HOME> ^
imap <HOME> <ESC>^i
inoremap <C-V> <C-R>+
inoremap <S-Insert> <C-R>+
nmap <C-V> "+gp
vmap <C-C> "+y`>
vmap <C-X> "+x
vmap y y`>
noremap <silent> <F3> :set nohlsearch!<CR>
"noremap / :set hlsearch<CR>/
inoremap {<CR>  {<CR>}<Esc>O
"nmap s c$
nmap <C-A> ggVG
"Alt-/ searches for whatever's on the clipboard
nmap J <C-E>
nmap K <C-Y>
vmap / y/<C-R>0
"imap <C-S-V> <C-V>
vmap <silent> <C-R> V0<C-V>I#<ESC>
vmap <silent> <C-T> :s/\v^(\s*)#(.*)$/\1\2<CR>:noh<CR>
nmap <leader>p dd"0P
nmap <leader>P D"0p
nmap <leader>e de"0P
nmap <leader>mc /^[<=>]\{7\}<CR>
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

" Make ctrl-backspace send a ctrl-w
" needed for terminals on a Linux host
imap <C-H> <C-W>

" Set cache and backup directories, adapted from archlinux.vim
let &g:directory=$HOME . '/.cache/vim'
let &g:backupdir=&g:directory . '/backup//'
let &g:undodir=&g:directory . '/cache//'
let &g:directory=&g:directory . '/swap//'

if ! isdirectory(expand(&g:directory))
    silent! call mkdir(expand(&g:directory), 'p', 0700)
endif
if ! isdirectory(expand(&g:backupdir))
    silent! call mkdir(expand(&g:backupdir), 'p', 0700)
endif
if ! isdirectory(expand(&g:undodir))
    silent! call mkdir(expand(&g:undodir), 'p', 0700)
endif

" Try to get list formatting working for bullets as well
" Evil amounts of backslash escaping = no fun
set formatlistpat=^\\s*[\\d*-]\\+[\\]:.)}\\t\ ]\\s*

" solarized light/dark toggle
call togglebg#map("<F7>")

" ctrlp.vim mappings/settings
nnoremap <C-P> :CtrlP<cr>
"let g:ctrlp_root_markers = ['.repo']
let g:ctrlp_custom_ignore = {'dir': '\v[/](\.(pc|repo|git)|venv)$'}
let g:ctrlp_max_files = 500000
let g:ctrlp_switch_buffer = ''
" if fd exists, use it to populate ctrlp rather than the slow builtin
" vimscript searcher
if executable("fd")
    let g:ctrlp_user_command = 'fd -tf -- . %s'
    if !has("windows")
        let g:ctrlp_user_command_async = 1
    endif
endif

" Airline customization
" solarized dark theme with powerline fonts
let g:airline_powerline_fonts = 1
let g:airline_solarized_dark_bg = 'dark'
let g:airline_solarized_dark_termcolors = 256
let g:airline_theme = 'solarized_dark'
" skip empty sections so there's no extra triangles
let g:airline_skip_empty_sections = 1
" disable tmuxline, I exported the tmux theme then customized it
let g:airline#extensions#tmuxline#enabled = 0
" whitespace warning checks
let g:airline#extensions#whitespace#checks = ['indent', 'trailing']
let g:airline#extensions#whitespace#mixed_indent_algo = 2
let g:airline#extensions#whitespace#trailing_format = '[%s]trailing'
let g:airline#extensions#whitespace#mixed_indent_format = '[%s]mix-indt'
" VCS info, enable git only
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#vcs_priority = ['git']
let g:airline#extensions#branch#format = 2
" don't inform about dirty/untracked files
let g:airline#extensions#branch#vcs_checks = []
" don't show file encoding if it's the usual UTF-8/unix format
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
" lighter weight right-hand section (line/column numbers)
let g:airline_section_z = airline#section#create(['linenr', 'maxlinenr', '%4v'])

" Disable line number symbol, it's just visual fluff. Have to define the map first to avoid
" errors when starting up vim
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr = ''

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

" NERDTree Options
let g:NERDTreeIgnore = ['\.o$', '\.pyc$']
let g:NERDTreeMapOpenSplit = "s"
let g:NERDTreeMapOpenVSplit = "v"
" Disable error messages if git isn't installed. (LogLevel is inverted, higher
" numbers mean to be quieter)
let g:NERDTreeGitStatusLogLevel = 4

" Python syntax highlighting options
let g:python_highlight_all = 1
let g:python_highlight_space_errors = 0
let g:python_highlight_indent_errors = 0

" misc syntax highlighting options
let g:go_highlight_trailing_whitespace_error = 0
let g:dosbatch_colons_comment = 0

cnoreabbrev Ag Ack!
nnoremap <leader>a :Ack!<space>
let g:ackprg = 'ag --vimgrep'

" use s/S for horizontal splits (default h/H)
let g:ack_mappings = {
      \ "s": "<C-W><CR><C-W>s",
      \ "S": "<C-W><CR><C-W>s<C-W>b" }

if has("win32")
    nmap <F11> :so ~/_vimrc<CR>
else
    nmap <F11> :so ~/.vimrc<CR>
endif

command! Space set et | retab | set noet
command! Tab set tabstop=3 | retab! | set tabstop=4 | set noet
command! -nargs=1 Wrap set cc=<args> | set tw=<args> | set formatoptions+=tc
command! NT NERDTree
command! TL TlistToggle
command! Trailsp %s/\s\+$//e | noh
command! Rustfmt normal! mr:%!rustfmt --edition 2021<CR>g'r
command! Ktab set noet ts=8 sts=8 sw=8

if !has("gui_running")
    command! Htop execute 'silent !htop' | redraw!
endif

" Disregard deprecation, restore :Gblame
command! Gblame Git blame


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
    " Fix shift-insert in gvim, from archlinux.vim
    map <S-Insert> <MiddleMouse>
    map! <S-Insert> <MiddleMouse>

    set background=dark
    colorscheme solarized
    set cursorline
    set tabpagemax=100
    if has("win32")
        "au GUIEnter * simalt ~x " maximize on startup
        set guifont=Cascadia_Mono_PL_SemiLight:h10:W350
    else
        " default GUI font on Linux
        "set guifont=Noto\ Mono\ for\ Powerline\ 10
        set guifont=Cascadia\ Mono\ PL\ Semi-Light\ 10
    endif
else
    colorscheme bluegreen
endif

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Disable the PKGBUILD file detection, I want normal sh syntax
augroup ftdetect_pkgbuild
    au!
augroup END

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

    " Reload Airline when . Not sure why this is necessary but if fixes the current
    " git branch info missing when I disabled the dirty/untracked flags.
    autocmd BufWinEnter * AirlineRefresh!

    " start NERDTree if opening a directory
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

" allow for local overrides
if filereadable(expand("~/.vimrc_local"))
    source ~/.vimrc_local
endif
