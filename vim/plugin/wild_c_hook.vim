""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatically set indentation settings for the linux kernel C code
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists('g:loaded_wild_c_hook') || !has('unix')
    finish
endif
let g:loaded_wild_c_hook = 1

function s:wild_c_hook()
    silent let b:top_gitdir = substitute(
                \ system('git -C ' . expand('%:p:h:S') . ' rev-parse --show-toplevel'),
                \ '\n\+$', '', '')
    if !empty(b:top_gitdir)
        let b:linuxkernel_checkfile = b:top_gitdir . '/include/linux/kernel.h'
        if filereadable(b:linuxkernel_checkfile)
            let &l:expandtab = 0
            let &l:tabstop = 8
            let &l:softtabstop = 8
            let &l:shiftwidth = 8
        endif
        unlet b:linuxkernel_checkfile
    endif
    unlet b:top_gitdir
endfunction

augroup WildCHook
    autocmd!
    autocmd FileType c,cpp,dts,make :call s:wild_c_hook()
augroup END
