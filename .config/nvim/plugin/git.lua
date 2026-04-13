local u = require'utils'
u.pack(
  'https://github.com/akinsho/git-conflict.nvim', -- resolve conflicts
  'https://github.com/lewis6991/gitsigns.nvim' -- git gutter
)

require 'git-conflict'.setup {
  disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
  default_mappings = {
    ours = 'gCo',
    theirs = 'gCt',
    none = 'gC0',
    both = 'gCb',
    next = '[x',
    prev = ']x',
  },
  highlights = { -- They must have background color, otherwise the default color will be used
    incoming = 'DiffText',
    current = 'DiffAdd',
  }
}


require 'gitsigns'.setup {
  current_line_blame = true,
}
