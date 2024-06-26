-- resolve conflicts
return { 'akinsho/git-conflict.nvim',
  enabled = true,
  event = { 'BufEnter' },
  opts = {
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
  },
}

