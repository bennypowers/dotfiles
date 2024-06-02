-- language-server diagnostics panel
return { 'folke/lsp-trouble.nvim',
  enabled = true,
  lazy = true,
  cmd = { 'Trouble', 'TroubleToggle' },
  dependencies = {
    'folke/trouble.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    {'gT', ':TroubleToggle<cr>', desc = 'Toggle trouble'},
  },
  opts = {
    auto_open = false,
    auto_close = true,
    auto_preview = true,
    use_diagnostic_signs = true,
  },
  init = function()
    au('BufNew', {
      pattern = "Trouble",
      command = "setlocal colorcolumn=0"
    })
  end
}

