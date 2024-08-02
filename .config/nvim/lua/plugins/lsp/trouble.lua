-- language-server diagnostics panel
return { 'folke/lsp-trouble.nvim',
  enabled = true,
  lazy = true,
  cmd = { 'Trouble' },
  dependencies = {
    'folke/trouble.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    {'<leader>td', ':Trouble diagnostics<cr>', desc = 'Toggle trouble (diagnostics)' },
    {'<leader>ts', ':Trouble symbols<cr>', desc = 'Toggle trouble (symbols)' },
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

