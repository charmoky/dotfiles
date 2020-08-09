syntax on
filetype on
set ts=8
set sw=8
set foldmethod=syntax

filetype plugin indent on

" Tab is 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab 

" Toggle paste mode by pushing F3
set pastetoggle=<F3>

" Activate the mouse + fix for split resizing in tmux
set mouse=a
if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif

" colors
"colorscheme desert 
colorscheme elflord
set background=dark

" search go downwards and is highlighted
set incsearch
set hlsearch

" new line at 120 characters + no line indentation on txt file
set tw=120
autocmd BufNewFile,BufRead *.txt set tw=0

set bs=2
set cindent		" always set c-indenting on

" line numbers
set number
set updatecount=100
nmap <C-n> :set invnumber<CR>

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Get interactive menu
set wildmenu

