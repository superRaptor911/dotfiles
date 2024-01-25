vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob/bfredl/nvim-ipy:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("settings")
require("lazy").setup({
    "tpope/vim-commentary",
    "vim-airline/vim-airline",
    "vim-airline/vim-airline-themes",
    "godlygeek/tabular",
    "qpkorr/vim-bufkill",
    "tpope/vim-surround",
    "danro/rename.vim",
    "nvim-tree/nvim-web-devicons",
    "nvim-tree/nvim-tree.lua",

    "ellisonleao/gruvbox.nvim",
    "sainnhe/edge",
    "dracula/vim",
    "navarasu/onedark.nvim",
    "tribela/vim-transparent",
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    "tpope/vim-fugitive",
    "github/copilot.vim",
    "mbbill/undotree",

    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },         -- Required
            { 'hrsh7th/cmp-nvim-lsp' },     -- Required
            { 'hrsh7th/cmp-buffer' },       -- Optional
            { 'hrsh7th/cmp-path' },         -- Optional
            { 'saadparwaiz1/cmp_luasnip' }, -- Optional
            { 'hrsh7th/cmp-nvim-lua' },     -- Optional

            -- Snippets
            { 'L3MON4D3/LuaSnip' }, -- Required
            -- {'rafamadriz/friendly-snippets'}, -- Optional

        }
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    "akinsho/toggleterm.nvim",
    'rmagatti/auto-session',
    'sbdchd/neoformat',
}, {})

require("auto-session").setup {
    log_level = "error",
    auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
}

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "help" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    auto_install = true,

    highlight = {
        -- `false` will disable the whole extension
        enable = true,

        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,

        additional_vim_regex_highlighting = false,
    },
}

local lsp = require('lsp-zero').preset("recommended")
lsp.ensure_installed({
    'tsserver',
    'eslint',
    'rust_analyzer'
})


lsp.on_attach(function(client, bufnr)
    local map = function(mode, lhs, rhs)
        local opts = { remap = false, buffer = bufnr }
        vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- LSP actions
    map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
    map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    -- map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    map('n', '<C-k>', '<C-u>')
    map('n', 'ge', '<cmd>lua vim.lsp.buf.rename()<cr>')
    map('n', 'do', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    map('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

    -- Diagnostics
    map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
    map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
end)

lsp.format_on_save({
    format_opts = {
        async = false,
        timeout_ms = 10000,
    },
    servers = {
        ['lua_ls'] = { 'lua' },
        ['rust_analyzer'] = { 'rust' },
        -- if you have a working setup with null-ls
        -- you can specify filetypes it can format.
        -- ['null-ls'] = {'javascript', 'typescript'},
    }
})


lsp.setup()

local cmp = require("cmp")
cmp.setup({
    mapping = {
        ["<CR>"] = cmp.mapping({
            i = function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                else
                    fallback()
                end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        }),
    }
})


vim.diagnostic.config({
    virtual_text = true,
})

local actions = require('telescope.actions')
require('telescope').setup {
    pickers = {
        buffers = {
            sort_lastused = true
        }
    }
}

require("keymaps")
require("nvim-tree").setup({
    update_focused_file = { enable = true }
})
require("toggleterm").setup()
require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.config/nvim/UltiSnips" })
-- require('onedark').load()
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
-- vim.cmd('colorscheme gruvbox')
