map <buffer> <C-k> :wa<CR>:!tmux send-keys -t 1-run-core C-u "try_make" Enter<CR><CR>
