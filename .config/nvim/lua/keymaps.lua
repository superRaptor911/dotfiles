local builtin = require('telescope.builtin')

local function vnmap(shortcut, command)
    vim.api.nvim_set_keymap("v", shortcut, command, { noremap = true })
end

local function tnmap(shortcut, command)
    vim.api.nvim_set_keymap("t", shortcut, command, { noremap = true })
end

local function nnmap(shortcut, command)
    vim.api.nvim_set_keymap("n", shortcut, command, { noremap = true })
end

local function inmap(shortcut, command)
    vim.api.nvim_set_keymap("i", shortcut, command, { noremap = true })
end

local function nmap(shortcut, command)
    vim.api.nvim_set_keymap("n", shortcut, command, { silent = true })
end

nnmap("L", "$")
nnmap("H", "0")
nnmap("dL", ":normal! d$<CR>")
nnmap("dH", ":normal! d0<CR>")

vnmap("<C-l>", "$")
vnmap("<C-h>", "0")

nnmap("Q", "@q")
nnmap("<S-Up>", "<C-u>")
nnmap("<S-Down>", "<C-d>")
nnmap("<C-k>", "<C-u>")
nnmap("<C-j>", "<C-d>")

nnmap(";r", ":Rename ")

nnmap(";e", "i<C-r>=<C-r>\"<cr><esc>")
nnmap("<C-Up>", ":bn<CR>")
nnmap("<C-Down>", ":bp<CR>")
nnmap("<C-Right>", ":BD<CR>")
nnmap("<C-Left>", ":ls<CR>")
nnmap("<S-Up>", "<C-u>")
nnmap("<S-Down>", "<C-d>")
nnmap("<C-k>", "<C-u>")
nnmap("<C-j>", "<C-d>")


-- Tabs
nnmap("<Tab>", ">>")
nnmap("<S-Tab>", "<<")
vnmap("<Tab>", ">><Esc>gv")
vnmap("<S-Tab>", "<<<Esc>gv")


-- Spell
nnmap("<F2>", ":set spell!<CR>")
nnmap("s", ":w<CR>")
nnmap("ss", ":wa<CR>")
-- nnmap("ZZ", ":NvimTreeClose<CR>ZZ")

inmap("(", "()<Esc>i")
inmap("{", "{}<Esc>i")
inmap("[", "[]<Esc>i")
inmap("\"", "\"\"<Esc>i")
inmap("\'", "\'\'<Esc>i")


-- Input mode movements
inmap("<C-k>", "<Up>")
inmap("<C-j>", "<Down>")
inmap("<C-h>", "<Left>")
inmap("<C-l>", "<Right>")

nnmap("oo", "o<Esc>")
vim.keymap.set('n', "<C-b>", builtin.buffers, {})
vim.keymap.set('n', "<C-f>", builtin.git_files, {})
vim.keymap.set('n', "<C-s>", builtin.live_grep, {})

nnmap("<C-t>", ":ToggleTerm<CR>")
nnmap("U", ":UndotreeToggle<CR>")
nnmap("<C-n>", ":NvimTreeToggle<CR>")

nnmap("<C-e>", "<cmd>TroubleToggle<cr>")

-- tnmap("<Esc>", "<C-\\><C-n>")
--
function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
vim.cmd('imap <silent><script><expr> <C-a> copilot#Accept("\\<CR>")')

-- vim.cmd('autocmd BufWritePost,FileWritePost *.js,*.jsx,*.ts,*.tsx,*.mjs silent! !prettier --write <afile>')
-- vim.api.nvim_command([[
-- autocmd BufWritePost,FileWritePost *.js,*.jsx,*.ts,*.tsx,*.mjs silent! !prettier --write <afile>
-- ]])

-- vim.api.nvim_command([[
--     autocmd BufWritePost,FileWritePost *.py silent! !black <afile>
-- ]])
