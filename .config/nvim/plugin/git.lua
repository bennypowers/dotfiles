local u = require 'utils'
u.pack(
  'https://github.com/akinsho/git-conflict.nvim', -- resolve conflicts
  'https://github.com/lewis6991/gitsigns.nvim' -- git gutter
)

require('git-conflict').setup {
  disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
  default_mappings = false,
  highlights = { -- They must have background color, otherwise the default color will be used
    incoming = 'DiffText',
    current = 'DiffAdd',
  },
}

u.nmap('gCo', '<Plug>(git-conflict-ours)', 'Choose ours')
u.nmap('gCt', '<Plug>(git-conflict-theirs)', 'Choose theirs')
u.nmap('gCb', '<Plug>(git-conflict-both)', 'Choose both')
u.nmap('gC0', '<Plug>(git-conflict-none)', 'Choose none')
u.nmap('[x', '<Plug>(git-conflict-prev-conflict)', 'Next conflict')
u.nmap(']x', '<Plug>(git-conflict-next-conflict)', 'Prev conflict')

require('gitsigns').setup {
  current_line_blame = true,
}
