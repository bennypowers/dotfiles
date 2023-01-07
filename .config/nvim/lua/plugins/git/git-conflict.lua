local CMDS = {
  'GitConflictChooseOurs',
  'GitConflictChooseTheirs',
  'GitConflictChooseBoth',
  'GitConflictChooseNone',
  'GitConflictNextConflict',
  'GitConflictPrevConflict',
  'GitConflictListQf',
}

-- resolve conflicts
return { 'akinsho/git-conflict.nvim', cmd = CMDS, config = function()

require 'git-conflict'.setup {
  default_mappings = true, -- disable buffer local mapping created by this plugin
  disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
  highlights = { -- They must have background color, otherwise the default color will be used
    incoming = 'DiffText',
    current = 'DiffAdd',
  }
}

end }
