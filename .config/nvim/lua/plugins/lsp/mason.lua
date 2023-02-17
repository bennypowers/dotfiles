-- 🤖 Language Servers, automatically installed
return { 'williamboman/mason-lspconfig.nvim',
  dependencies = {
    'williamboman/mason.nvim',
    'neovim/nvim-lspconfig',
  },

  config = function()
    require 'mason'.setup()
    require 'mason-lspconfig'.setup {
      automatic_installation = true,
    }
  end,
}
