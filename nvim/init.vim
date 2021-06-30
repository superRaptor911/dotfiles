set nocompatible
filetype off
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle')
Plugin 'preservim/nerdtree'
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-commentary'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'habamax/vim-godot'
Plugin 'godlygeek/tabular'
Plugin 'neoclide/coc.nvim'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'qpkorr/vim-bufkill'
Plugin 'tpope/vim-surround'
Plugin 'danro/rename.vim'
" Color scheme
Plugin 'morhetz/gruvbox'
Plugin 'sainnhe/edge'
Plugin 'dracula/vim'
" Syntax
Plugin 'octol/vim-cpp-enhanced-highlight'
" Plugin 'jelera/vim-javascript-syntax'
" Plugin 'peitalin/vim-jsx-typescript'
Plugin 'yuezk/vim-js'
Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'SirVer/ultisnips'
Plugin 'mlaursen/vim-react-snippets'
Plugin 'honza/vim-snippets'
Plugin 'vim-python/python-syntax'
call vundle#end()

set termguicolors
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
colorscheme gruvbox
filetype plugin on
filetype indent on

" Auto insert mode caret to beam
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" C/C++
autocmd FileType cpp inoremap ;if if()<CR>{<CR>}<Esc>kk$i
autocmd FileType cpp inoremap ;fi for(int i = 0; i < ; i++)<CR>{<CR>}<Esc>kkf<a
autocmd FileType cpp inoremap ;cl class<CR>{<CR><BS>public:<CR>};<Esc>3k$a<Space>
autocmd FileType cpp inoremap ;st struct<CR>{<CR>};<Esc>2k$a<Space>
autocmd FileType cpp nnoremap <F5> :!g++ -o  %:r.out % -std=c++17<CR>
autocmd FileType cpp nnoremap <F6> :!./%:r.out

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

" Godot
autocmd FileType gdscript inoremap ;r onready var  = get_node() <Esc>3bhi
autocmd FileType gdscript inoremap ;c connect("", self, "") <Esc>T(a
autocmd FileType gdscript inoremap ;fi for i in : <Esc>i
autocmd FileType gdscript inoremap ;pl  preload("res://")<Esc>$hi

" json
autocmd FileType json nnoremap ;b :%!python -m json.tool<CR>

" Javascript
autocmd Filetype javascript setlocal ts=2 sw=2 expandtab

autocmd FileType markdown nnoremap <F5> :!markdown -f html -o doc.html % <CR><CR>
" Global keybindings
" Run macro with Q
nnoremap Q @q
" Movement tweak
noremap H 0
noremap L $
nnoremap <S-Up> <C-u>
nnoremap <S-Down> <C-d>
nnoremap <C-k> <C-u>
nnoremap <C-j> <C-d>

" Buffers
nnoremap <C-Up> :bn<CR>
nnoremap <C-Down> :bp<CR>
nnoremap <C-Right> :BD<CR>
nnoremap <C-Left> :ls<CR>

" Tabs
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
" complete insertion at end
inoremap ii <Esc><Esc>l
inoremap ( ()<Esc>i
inoremap { {}<Esc>i
inoremap [ []<Esc>i
inoremap " ""<Esc>i
inoremap ' ''<Esc>i
" Input mode movements
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

nnoremap oo o<Esc>
nnoremap <C-f> :GFiles<CR>
nnoremap <C-b> :Buffers<CR>

" COC config
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
" set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
" set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

inoremap <silent><expr> <Down>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Down>" :
      \ coc#refresh()

inoremap <silent><expr> <Up>
      \ pumvisible() ? "\<C-p>" :
      \ <SID>check_back_space() ? "\<Up>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? "\<Space>\<Backspace>" : "\<CR>"
" inoremap <silent><expr> <Right> pumvisible() ? "<Space>" : "\<Right>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> ge <Plug>(coc-rename)
nmap <silent> do <Plug>(coc-codeaction)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction


" Snippets
" " Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<F3>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" " If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:python_highlight_all = 1
