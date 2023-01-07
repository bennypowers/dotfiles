local DEPS = {
  'folke/trouble.nvim',
  'web-devicons'
}

-- language-server diagnostics panel
return { 'folke/lsp-trouble.nvim', lazy = true, command = { 'Trouble', 'TroubleToggle' }, dependencies = DEPS, config = function()

local trouble = require 'trouble'
trouble.setup {
  auto_open = false,
  auto_close = true,
  auto_preview = true,
  use_diagnostic_signs = true,
}

au('BufNew', {
  pattern = "Trouble",
  command = "setlocal colorcolumn=0"
})

end }
