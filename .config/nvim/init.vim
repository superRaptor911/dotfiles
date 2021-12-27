set nocompatible
filetype off
call plug#begin('~/.vim/plugged')
" Plug 'preservim/nerdtree'
" Plug 'VundleVim/Vundle.vim'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'habamax/vim-godot'
Plug 'godlygeek/tabular'
Plug 'neoclide/coc.nvim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'tpope/vim-surround'
Plug 'danro/rename.vim'
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" " Color scheme
Plug 'morhetz/gruvbox'
Plug 'sainnhe/edge'
Plug 'dracula/vim'
Plug 'tribela/vim-transparent'
Plug 'tomlion/vim-solidity'

" " Syntax
Plug 'octol/vim-cpp-enhanced-highlight'
" Plug 'jelera/vim-javascript-syntax'
" Plug 'peitalin/vim-jsx-typescript'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'SirVer/ultisnips'
Plug 'mlaursen/vim-react-snippets'
Plug 'honza/vim-snippets'
Plug 'vim-python/python-syntax'
call plug#end()

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
autocmd FileType cpp nnoremap <F5> :!g++ -o  %:r.out % -std=c++17<CR>
autocmd FileType cpp nnoremap <F6> :!./%:r.out

" HTML
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd FileType html inoremap ;; <C-X><C-O>
autocmd FileType html inoremap </ </<C-X><C-O>


" Godot
autocmd FileType gdscript inoremap ;r onready var  = get_node() <Esc>3bhi
autocmd FileType gdscript inoremap ;c connect("", self, "") <Esc>T(a
autocmd FileType gdscript inoremap ;fi for i in : <Esc>i
autocmd FileType gdscript inoremap ;pl  preload("res://")<Esc>$hi

" json
autocmd FileType json nnoremap ;b :%!python -m json.tool<CR>

" Javascript
autocmd Filetype javascript setlocal ts=2 sw=2 expandtab
" Markdown
autocmd FileType markdown nnoremap <F5> :!markdown -f html -o %.html % <CR><CR>
autocmd FileType markdown nnoremap <F6> :!wkhtmltopdf %.html %.pdf <CR><CR>


autocmd BufWritePost *.py !autopep8 --in-place --aggressive --aggressive <afile>

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
nnoremap ms :wa<CR>:NvimTreeClose<CR>:mks! .session.vim<CR>
nnoremap so :so .session.vim<CR>
" Save and quit session
nnoremap ZS :wa<CR>:mks! .session.vim<CR>:qa<CR>
" complete insertion at end
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
let g:UltiSnipsExpandTrigger="<F3>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" " If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:python_highlight_all = 1

" NvimTree
let g:nvim_tree_quit_on_open = 1 "0 by default, closes the tree when you open a file
let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
let g:nvim_tree_disable_window_picker = 1 "0 by default, will disable the window picker.
let g:nvim_tree_icon_padding = '  ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
let g:nvim_tree_symlink_arrow = ' >> ' " defaults to ' ➛ '. used as a separator between symlinks' source and target.
let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
let g:nvim_tree_create_in_closed_folder = 0 "1 by default, When creating files, sets the path of a file when cursor is on a closed folder to the parent folder when 0, and inside the folder when 1.
let g:nvim_tree_refresh_wait = 1500 "1000 by default, control how often the tree can be refreshed, 1000 means the tree can be refresh once per 1000ms.
let g:nvim_tree_window_picker_exclude = {
    \   'filetype': [
    \     'notify',
    \     'packer',
    \     'qf'
    \   ],
    \   'buftype': [
    \     'terminal'
    \   ]
    \ }
" Dictionary of buffer option names mapped to a list of option values that
" indicates to the window picker that the buffer's window should not be
" selectable.
let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 1,
    \ 'files': 1,
    \ 'folder_arrows': 0,
    \ }
"If 0, do not show the icons for one of 'git' 'folder' and 'files'
"1 by default, notice that if 'files' is 1, it will only display
"if nvim-web-devicons is installed and on your runtimepath.
"if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
"but this will not work when you set indent_markers (because of UI conflict)

" default will show icon by default if no icon is provided
" default shows no icon by default
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   }
    \ }

nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>
" NvimTreeOpen, NvimTreeClose, NvimTreeFocus, NvimTreeFindFileToggle, and NvimTreeResize are also available if you need them

set termguicolors " this variable must be enabled for colors to be applied properly
" a list of groups can be found at `:help nvim_tree_highlight`
highlight NvimTreeFolderIcon guibg=blue


lua << EOF
    require'nvim-tree'.setup {
        disable_netrw       = true,
        hijack_netrw        = true,
        open_on_setup       = false,
        ignore_ft_on_setup  = {},
        auto_close          = false,
        open_on_tab         = false,
        hijack_cursor       = false,
        update_cwd          = false,
        update_to_buf_dir   = {
        enable = true,
        auto_open = true,
        },
    diagnostics = {
    enable = false,
    icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
        }
    },
update_focused_file = {
enable      = false,
update_cwd  = false,
ignore_list = {}
},
  system_open = {
      cmd  = nil,
      args = {}
      },
  filters = {
      dotfiles = false,
      custom = {}
      },
  git = {
  enable = true,
  ignore = true,
  timeout = 500,
  },
  view = {
      width = 30,
      height = 30,
      hide_root_folder = false,
      side = 'left',
      auto_resize = false,
      mappings = {
          custom_only = false,
          list = {}
          },
      number = false,
      relativenumber = false
      },
  trash = {
      cmd = "trash",
      require_confirm = true
      }
  }
EOF
