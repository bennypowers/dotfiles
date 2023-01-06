-- highlight matching paren
return { 'monkoose/matchparen.nvim', config = function()

require 'matchparen'.setup {
  on_startup = true,
}

end }
