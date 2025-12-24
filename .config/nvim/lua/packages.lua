require("lazy").setup({
    "tpope/vim-commentary",
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
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
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
        }
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
    {
        "hat0uma/csvview.nvim",
        ---@module "csvview"
        ---@type CsvView.Options
        opts = {
            parser = { comments = { "#", "//" } },
            keymaps = {
                -- Text objects for selecting fields
                textobject_field_inner = { "if", mode = { "o", "x" } },
                textobject_field_outer = { "af", mode = { "o", "x" } },
                -- Excel-like navigation:
                -- Use <Tab> and <S-Tab> to move horizontally between fields.
                -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
                -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
                jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
                jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
                jump_next_row = { "<Enter>", mode = { "n", "v" } },
                jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
            },
        },
        cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    }
}, {})
