if !exists('*Black_format')
    func! Black_format()
        let save_cursor = getcurpos()
        exe 'w'
        exe 'silent !black %'
        exe 'edit'
        call setpos('.', save_cursor)
    endfunc
endif

nnoremap <buffer> <C-f> :call Black_format()<CR> :redraw!<CR>
