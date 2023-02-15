-- 🤖 Language Servers, automatically installed
return { 'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
  },

  config = function()
    require 'mason'.setup()
    require 'mason-lspconfig'.setup {
      automatic_installation = true,
    }
  end,
}
