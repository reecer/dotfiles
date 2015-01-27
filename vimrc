set nocompatible
set laststatus=2
set rtp+=~/.vim/bundle/Vundle.vim
filetype off

execute pathogen#infect()

" Highlight line number of where cursor currently is
hi CursorLineNr guifg=#050505

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
let g:airline_theme='solarized'
set t_Co=256


call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'
call vundle#end()
filetype plugin indent on

" Color scheme
colorscheme solarized
set background=dark
set encoding=utf-8
