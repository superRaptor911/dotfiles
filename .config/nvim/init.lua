vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("settings")
require("packages")

require("mason").setup()
require("auto-session").setup {
    log_level = "error",
    auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
}


require('telescope.actions')
require('telescope').setup {
    pickers = {
        buffers = {
            sort_lastused = true
        }
    }
}

require("lspSetup")
require("keymaps")
require("nvim-tree").setup({
    update_focused_file = { enable = true }
})

require("toggleterm").setup()
require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.config/nvim/UltiSnips" })
-- require('onedark').load()
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
