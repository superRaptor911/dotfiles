local set = vim.opt
set.termguicolors = true
set.number = true
set.relativenumber = true
set.syntax = "on"
set.linebreak = true
set.showbreak = "+++"
set.textwidth = 100
set.showmatch = true


-- set.ssop-=options
-- set.ssop-=folds
set.hlsearch = true
set.smartcase = true
set.ignorecase = true
set.incsearch = true

set.autoindent = true
set.smartindent = true
set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.expandtab = true
-- set.wrap = false

set.ruler = true
set.shell = "/bin/fish"
set.undolevels = 1000
-- set.backspace=indent,eol,start
set.clipboard = "unnamedplus"
set.scrolloff = 8
set.updatetime = 50
--syntax enable
--colorscheme gruvbox
--filetype plugin on
--filetype indent on

-- set.syntax = "enable"

-- Filetype plugins and indentation
-- set.loaded_filetype_plugin = 1
-- set.loaded_indent = 1

vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = { "*" },
})
