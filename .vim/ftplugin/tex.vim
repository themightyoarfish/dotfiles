" Compile to pdf
map <buffer> <C-k> :w<CR>:!pdflatex "%"<CR>

" When using makefile
map <buffer> <C-m> :wa<CR>:!make<CR>

" Umlauts, in case one does not \usepackage[utf8]{inputenc}
"inoremap <buffer> <Char-246> \"o
"inoremap <buffer> <Char-228> \"a
"inoremap <buffer> <Char-252> \"u
"inoremap <buffer> ß \ss{}
"inoremap <buffer> <Char-196> \"A
"inoremap <buffer> <Char-220> \"U
"inoremap <buffer> <Char-214> \"O 

" Open pdf
map <buffer> <C-l> :!open -a Skim "%<.pdf" <CR><CR>

" Autocompletion of dollar sign
inoremap <buffer> $ $$<Esc>i

set textwidth=120 " for long equations
