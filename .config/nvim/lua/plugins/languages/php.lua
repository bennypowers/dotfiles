-- Lua
return { 'gbprod/phpactor.nvim',
  enabled = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  build = function()
    require'phpactor.handler.update'()
  end,
  opts = {
  },
}
