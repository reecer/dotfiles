set nocompatible
set laststatus=2
set rtp+=~/.vim/bundle/Vundle.vim
filetype off

set autoindent
syntax on

" Highlight current line
set cursorline

" No hard tabs
set expandtab
set shiftwidth=2
set softtabstop=2

"Tab width
set shiftwidth=2
set tabstop=2

" Numbers
set number
set numberwidth=5

" Toggle nerdtree with F10
map <F10> :NERDTreeToggle<CR>
" Current file in nerdtree
map <F9> :NERDTreeFind<CR>

" Airline statusbar
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
set t_Co=256

" Plugins
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'tomasr/molokai'
Plugin 'edkolev/tmuxline.vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'
call vundle#end()


filetype plugin indent on

" Color scheme
colorscheme molokai 
set background=dark
set encoding=utf-8
