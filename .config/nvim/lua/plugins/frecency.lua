-- tries to sort files helpfully
return { 'nvim-telescope/telescope-frecency.nvim',
  requires = 'tami5/sqlite.lua',
  enabled = false,
  config = function()
    require 'telescope'.load_extension 'frecency'
  end }

