require("mason-lspconfig").setup()
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
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    local map = function(mode, lhs, rhs)
        local opts = { remap = false, buffer = bufnr }
        vim.keymap.set(mode, lhs, rhs, opts)
    end

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

  end
})

vim.diagnostic.config({
    virtual_text = true,
})

local cmp = require('cmp')
cmp.setup({
  completion = {
    keyword_length = 2,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = ""  -- hide icon/kind text
      return vim_item
    end
  },

    -- snippet = {
    --       -- REQUIRED - you must specify a snippet engine
    --       expand = function(args)
    --         require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    --       end,
    --     },

})
