-- Lua
return { 'gbprod/phpactor.nvim',
  enabled = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'neovim/nvim-lspconfig'
  },
  build = function()
    require'phpactor.handler.update'()
  end,
  opts = {
  },
}
