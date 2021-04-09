set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'preservim/nerdtree'
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-commentary'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'habamax/vim-godot'
Plugin 'godlygeek/tabular'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
" Plugin 'ycm-core/YouCompleteMe'
call vundle#end()

set number
set relativenumber
syntax on
set linebreak
set showbreak=+++
set textwidth=100
set showmatch	
set ssop-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds
set hlsearch
set smartcase
set ignorecase
set incsearch

set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4 
set expandtab

set ruler
set shell=/bin/bash
set undolevels=1000
set backspace=indent,eol,start
set clipboard=unnamedplus
syntax enable
colorscheme monokai
let g:ycm_autoclose_preview_window_after_completion=1
filetype plugin on
filetype indent on

" Auto insert mode caret to beam
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Godot auto-complete
if !has_key( g:, 'ycm_language_server' )
  let g:ycm_language_server = []
endif
let g:ycm_language_server += [
  \   {
  \     'name': 'godot',
  \     'filetypes': [ 'gdscript' ],
  \     'project_root_files': [ 'project.godot' ],
  \     'port': 6008
  \   }
  \ ]

" C/C++
autocmd FileType cpp inoremap ;if if()<CR>{<CR>}<Esc>kk$i
autocmd FileType cpp inoremap ;fi for(int i = 0; i < ; i++)<CR>{<CR>}<Esc>kkf<a
autocmd FileType cpp inoremap ;cl class<CR>{<CR><BS>public:<CR>};<Esc>3k$a<Space>
autocmd FileType cpp inoremap ;st struct<CR>{<CR>};<Esc>2k$a<Space>

" HTML
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd FileType html inoremap ;h1 <h1></h1><Esc>4hi
autocmd FileType html inoremap ;h2 <h2></h2><Esc>4hi
autocmd FileType html inoremap ;h3 <h3></h3><Esc>4hi
autocmd FileType html inoremap ;p < p></p><Esc>6hx2li
autocmd FileType html inoremap ;b < b></b><Esc>6hx2li
autocmd FileType html inoremap ;a < a></a><Esc>6hx2li
autocmd FileType html inoremap ;; <C-X><C-O>
autocmd FileType html inoremap </ </<C-X><C-O>

" PHP
autocmd FileType php inoremap ;if if() {<CR>}<Esc>k$2hi
autocmd FileType php inoremap ;fi for($i = 0; $i < ; $i++) {<CR>}<Esc>kf<a

" Global keybindings
" Run macro with Q
nnoremap Q @q
" Movement tweak
noremap H 0
noremap L $
" switch tabs
map <Esc>[5;5~ <kPageUp>
map <Esc>[6;5~ <kPageDown>
nnoremap <PageUp> :tabp<CR>
nnoremap <PageDown> :tabn<CR>
nnoremap <kPageUp> :tabm -1<CR>
nnoremap <kPageDown> :tabm +1<CR>
nnoremap <ESC>1<ESC>1 :tabn 1<CR>
nnoremap <ESC>2<ESC>2 :tabn 2<CR>
nnoremap <ESC>3<ESC>3 :tabn 3<CR>
nnoremap <ESC>4<ESC>4 :tabn 4<CR>
nnoremap <ESC>5<ESC>5 :tabn 5<CR>
nnoremap <ESC>6<ESC>6 :tabn 6<CR>
nnoremap <ESC>7<ESC>7 :tabn 7<CR>
nnoremap <ESC>8<ESC>8 :tabn 8<CR>
nnoremap <ESC>9<ESC>9 :tabn 9<CR>
" Indentation 
nnoremap <Tab>   >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >><Esc>gv
vnoremap <S-Tab> <<<Esc>gv
" Spell check
" map <F2> :setlocal spell! spelllang=en_us<CR>
nnoremap <F2> :set spell!<CR>
" Save shortcut
nnoremap s :w<CR>
nnoremap ss :wa<CR>
nnoremap ms :wa<CR>:mks! .session.vim<CR>
nnoremap so :so .session.vim<CR>
" Save and quit session
nnoremap ZS :wa<CR>:mks! .session.vim<CR>:qa<CR>
" Open NERDtree
nnoremap ;nt :NERDTree<CR>
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" complete insertion at end
inoremap ii <Esc><Esc>l
inoremap ( ()<Esc>i
inoremap { {<CR>}<Esc>ko
inoremap [ []<Esc>i
inoremap " ""<Esc>i
inoremap ' ''<Esc>i
" Input mode movements
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
