""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatically set indentation settings for the linux kernel C code
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists('g:loaded_wild_c_hook') || !has("unix")
    finish
endif
let g:loaded_wild_c_hook = 1

function s:wild_c_hook()
    silent let b:top_gitdir = system(join(
                \['git -C "', fnamemodify(expand('%'), ':p:h'), '" rev-parse --show-toplevel'], ''))
    let b:top_gitdir = substitute(b:top_gitdir, '\n\+$', '', '')
    if !empty(b:top_gitdir)
        let b:linuxkernel_checkfile = join([b:top_gitdir, '/include/linux/kernel.h'], '')
        if filereadable(b:linuxkernel_checkfile)
            let &l:expandtab = 0
            let &l:tabstop = 8
            let &l:shiftwidth = 8
        endif
        unlet b:linuxkernel_checkfile
    endif
    unlet b:top_gitdir
endfunction

augroup WildCHook
    autocmd!
    autocmd FileType c,cpp,make :call s:wild_c_hook()
augroup END
