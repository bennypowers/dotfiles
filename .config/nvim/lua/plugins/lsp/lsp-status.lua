-- support for reporting buffer's lsp status (diagnostics, etc) to other plugins
return { 'nvim-lua/lsp-status.nvim',
  config = function()
    local lsp_status = require 'lsp-status'
    lsp_status.config {
      current_function = false,
      kind_labels = vim.g.completion_customize_lsp_label,
      indicator_errors = '🔥',
      indicator_warnings = ' 🚧',
      indicator_info = 'ℹ️ ',
      indicator_hint = '🙋 ',
      indicator_ok = ' ',
      spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' },
      status_symbol = '',
      -- status_symbol = '💬: ',
      -- status_symbol = ' ',
    }
    lsp_status.register_progress()
  end
}
