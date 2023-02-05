-- resolve conflicts
return { 'akinsho/git-conflict.nvim', events = { 'BufEnter' }, opts = {
  disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
  default_mappings = {
    ours = 'o',
    theirs = 't',
    none = '0',
    both = 'b',
    next = 'n',
    prev = 'p',
  },
  highlights = { -- They must have background color, otherwise the default color will be used
    incoming = 'DiffText',
    current = 'DiffAdd',
  }
} }

