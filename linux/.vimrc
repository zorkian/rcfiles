set nocp
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab "will expand tabs to spaces when typed
"retab will expand all tabs in the current file to spaces
set sr
set cin
set smartindent
set autoindent
syntax on

set shell=/usr/bin/bash

" use "a to copy to that register, e.g. "ayy to move a line to register a, 
" or 3V"bd to move 3 lines to b and delete them
" <c-w> s to split horizontally, v for vertical, hjkl to navigate
" <c-w> = to make all split windows the same size

" Python smartindex hints
autocmd BufNewFile,BufRead *.py set cinwords=if,elif,else,for,while,try,except,finally,def,class

set clipboard=unnamed

"Show me line numbers
"set relativenumber " ONCE on 7.3
"set number

" format stuff
nnoremap \ vip:!par<CR>

"remap jkl to meta
inoremap lkj <Esc>

"Show matching parenthesis, brackets
set showmatch

"I want to highlight searches, and show the upcoming one
set incsearch
set hlsearch

"Show the position of the cursor.
set ruler

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

"Lazy pattern matching
set ignorecase smartcase

"Encoding
set encoding=utf-8

"Make sure at least 3 lines are showing on scroll
set scrolloff=3

"Draw a line under the current cursor line
set cursorline

"Wildcard completion modification
set wildmenu
set wildmode=list:longest

"Modify backspace behavior to be more powerful
set backspace=indent,eol,start

"Move between splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

"autocmd! BufNewFile * silent! 0r ~/.vim/templates/tmpl.%:e

" set colors Mark likes
colorscheme desert
