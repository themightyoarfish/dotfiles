" Don't load another plugin for this buffer
" let b:did_ftplugin = 1

" Run make wrapper
map <buffer> <C-k> :wa<CR>:!tmux send-keys -t 1-run-core C-c "try_make" Enter<CR><CR>
setlocal commentstring=/*%s*/
