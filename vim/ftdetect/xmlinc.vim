" Helpful for repo manifest XML includes that would get set to ft=bitbake otherwise
au BufNewFile,BufRead *.inc if getline(1) =~ '^<?xml' | set filetype=xml | endif
