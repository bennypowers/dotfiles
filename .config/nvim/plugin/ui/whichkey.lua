local u = require'utils'
-- Live cheat sheet for key bindings
u.pack 'folke/which-key.nvim'

local wk = require 'which-key'

wk.setup {
  preset = 'helix',
}

wk.add {
  mode = { 'n', 'v' },
  { '<leader>',   group = 'Leader' },
  { '<leader>d',  group = '+debug' },
  { '<leader>l',  group = 'LSP' },
  { '<leader>r',  group = '+re...' },
  { '<leader>ro', group = '+colours' },
  { '<leader>rc', group = '+caser' },
  { '<leader>s',  group = '+screenshots' },
  { '<leader>f',  group = '+picker' },
  { '<leader>x',  group = '+trouble' },
}

wk.add {
  mode = 'v',
  { 'gL',  name = 'align right' },
  { 'gl',  name = 'align left' },
  { 'g%',  name = 'match surround backwards' },
  { 'gn',  group = 'incremental' },
  { 'gnn', name = 'select' },
}
