local u = require'utils'
u.pack 'folke/lazydev.nvim'

require 'lazydev'.setup {
  library = {
    { path = vim.fn.stdpath 'data' .. '/site/pack/core/opt/snacks.nvim', words = { 'Snacks' } },
  },
}
