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
    "catppuccin/nvim",
    "tribela/vim-transparent",
    { "nvim-treesitter/nvim-treesitter",  build = ":TSUpdate" },
    "github/copilot.vim",
    "mbbill/undotree",

    { 'neovim/nvim-lspconfig', lazy = false, },                     -- Required
    { "mason-org/mason.nvim" },
    { "mason-org/mason-lspconfig.nvim" },         -- Optional


    { 'L3MON4D3/LuaSnip' },         -- Required

    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
        },
    },

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'hrsh7th/nvim-cmp',
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
        },
    },

        "akinsho/toggleterm.nvim",
        'rmagatti/auto-session',
        'sbdchd/neoformat',
    }, {})
