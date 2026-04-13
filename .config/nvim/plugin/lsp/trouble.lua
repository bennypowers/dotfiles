local u = require'utils'

u.pack 'folke/trouble.nvim'

require 'trouble'.setup {}

u.nmap('<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', 'Diagnostics (Trouble)')
u.nmap('<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', 'Buffer Diagnostics (Trouble)')
u.nmap('<leader>xq', '<cmd>Trouble qflist toggle<cr>', 'Quickfix (Trouble)')
u.nmap('<leader>xl', '<cmd>Trouble loclist toggle<cr>', 'Location List (Trouble)')
