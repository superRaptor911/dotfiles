set nocompatible
filetype off
call plug#begin('~/.vim/plugged')
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
" JS/X
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
" MDX
Plug 'jxnblk/vim-mdx-js'
" TS/X
Plug 'HerringtonDarkholme/yats.vim'
" Plug 'leafgarland/typescript-vim'
" Plug 'peitalin/vim-jsx-typescript'
Plug 'vim-python/python-syntax'

Plug 'SirVer/ultisnips'
Plug 'mlaursen/vim-react-snippets'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-fugitive'
Plug 'chrisbra/csv.vim'
Plug 'github/copilot.vim'
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
autocmd FileType cpp nnoremap <F5> :!g++ -o  %:r.out % -std=c++17 -Wall<CR>
autocmd FileType cpp nnoremap <F6> :!./%:r.out
function! Formatonsave()
  let l:formatdiff = 1
  pyf /usr/share/clang/clang-format.py
endfunction
autocmd BufWritePre *.h,*.cc,*.cpp call Formatonsave()

" HTML
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd FileType html inoremap ;; <C-X><C-O>
autocmd FileType html inoremap </ </<C-X><C-O>

" json
autocmd FileType json nnoremap ;b :%!python -m json.tool<CR>

" Javascript
autocmd Filetype javascript setlocal ts=2 sw=2 expandtab
" Markdown
autocmd FileType markdown nnoremap <F5> :!markdown -f html -o %.html % <CR><CR>
autocmd FileType markdown nnoremap <F6> :!wkhtmltopdf %.html %.pdf <CR><CR>
" Assembly
autocmd BufNew,BufRead *.asm set ft=masm
" autocmd FileType asm nnoremap <F6> :!r_buildAsm %<CR>
autocmd FileType asm nnoremap <F6> :!r_buildAsm %<CR><CR>
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

nnoremap ;r :Rename 
nnoremap ;e i<C-r>=<C-r>"<cr><esc> 

" Buffers
nnoremap <C-Up> :bn<CR>
nnoremap <C-Down> :bp<CR>
nnoremap <C-Right> :BD<CR>
nnoremap <C-Left> :ls<CR>

" Git !!!!!
nnoremap ;gw :Gwrite<CR>
nnoremap ;gs :Git status<CR>
nnoremap ;gl :Git log<CR>
nnoremap ;ga :Git add %<CR>
nnoremap ;gA :Git add .<CR>
nnoremap ;gs :Git status<CR>
nnoremap ;gc :Git commit<CR>
nnoremap ;gp :Git push<CR>

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

aug CSV_Editing
		au!
		au BufRead,BufWritePost *.csv :%ArrangeColumn
		au BufWritePre *.csv :%UnArrangeColumn
aug end

"-- FOLDING --  
set foldmethod=syntax "syntax highlighting items specify folds  
" set foldmethod=syntax
" set foldcolumn=1 "defines 1 col at window left, to indicate folding  
" let javaScript_fold=1 "activate folding by JS syntax  
set foldlevelstart=99 "start file with all folds opened

" COC config
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=500

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

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
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')


" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" " Remap <C-f> and <C-b> for scroll float windows/popups.
" if has('nvim-0.4.0') || has('patch-8.2.0750')
"   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Snippets
let g:UltiSnipsExpandTrigger="<F3>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" " If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:python_highlight_all = 1

"" NvimTree
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

set termguicolors " this variable must be enabled for colors to be applied properly
" a list of groups can be found at `:help nvim_tree_highlight`
" highlight NvimTreeFolderIcon guibg=blue


lua << EOF
require'nvim-tree'.setup { -- BEGIN_DEFAULT_OPTS
  auto_reload_on_write = true,
  create_in_closed_folder = false,
  disable_netrw = false,
  hijack_cursor = false,
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = false,
  ignore_buffer_on_setup = false,
  open_on_setup = false,
  open_on_setup_file = false,
  open_on_tab = false,
  sort_by = "name",
  update_cwd = false,
  reload_on_bufenter = false,
  respect_buf_cwd = false,
  view = {
    adaptive_size = false,
    centralize_selection = false,
    width = 30,
    hide_root_folder = false,
    side = "left",
    preserve_window_proportions = false,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
    mappings = {
      custom_only = false,
      list = {
        -- user mappings go here
      },
    },
  },
  renderer = {
    add_trailing = false,
    group_empty = false,
    highlight_git = false,
    full_name = false,
    highlight_opened_files = "none",
    root_folder_modifier = ":~",
    indent_markers = {
      enable = false,
      icons = {
        corner = "└ ",
        edge = "│ ",
        item = "│ ",
        none = "  ",
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = "before",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
    special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
  },
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = false,
    update_cwd = false,
    ignore_list = {},
  },
  ignore_ft_on_setup = {},
  system_open = {
    cmd = "",
    args = {},
  },
  diagnostics = {
    enable = false,
    show_on_dirs = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  filters = {
    dotfiles = false,
    custom = {},
    exclude = {},
  },
  filesystem_watchers = {
    enable = false,
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 400,
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    expand_all = {
      max_folder_discovery = 300,
    },
    open_file = {
      quit_on_open = false,
      resize_window = true,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
    remove_file = {
      close_window = true,
    },
  },
  trash = {
    cmd = "gio trash",
    require_confirm = true,
  },
  live_filter = {
    prefix = "[FILTER]: ",
    always_show_folders = true,
  },
  log = {
    enable = false,
    truncate = false,
    types = {
      all = false,
      config = false,
      copy_paste = false,
      diagnostics = false,
      git = false,
      profile = false,
      watcher = false,
    },
  },
} -- END_DEFAULT_OPTS
EOF
" autocmd BufNewFile,BufRead *.tsx setlocal filetype=typescript
set re=0
" let g:yats_host_keyword = 0
