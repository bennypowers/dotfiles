return function()
  vim.g.diagnostic_enable_virtual_text = 1
  vim.g.diagnostic_virtual_text_prefix = ' '
  vim.fn.sign_define("LspDiagnosticsSignError",       { text = "🔥", texthl = "LspDiagnosticsError"       })
  vim.fn.sign_define("LspDiagnosticsSignWarning",     { text = "🚧", texthl = "LspDiagnosticsWarning"     })
  vim.fn.sign_define("LspDiagnosticsSignInformation", { text = "👷", texthl = "LspDiagnosticsInformation" })
  vim.fn.sign_define("LspDiagnosticsSignHint",        { text = "🙋", texthl = "LspDiagnosticsHint"        })
end

