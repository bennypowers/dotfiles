local trouble = require 'trouble'
trouble.setup {
  auto_open = false,
  auto_close = true,
  auto_preview = true,
  use_diagnostic_signs = true,
}

vim.api.nvim_create_autocmd('BufNew', {
  pattern = "Trouble",
  command = "setlocal colorcolumn=0"
})
