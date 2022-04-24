return function()
  vim.g.diagnostic_enable_virtual_text = 1
  vim.g.diagnostic_virtual_text_prefix = ' '
  vim.fn.sign_define("DiagnosticSignError",       { text = "🔥", texthl = "DiagnosticError"       })
  vim.fn.sign_define("DiagnosticSignWarning",     { text = "🚧", texthl = "DiagnosticWarning"     })
  vim.fn.sign_define("DiagnosticSignInformation", { text = "👷", texthl = "DiagnosticInformation" })
  vim.fn.sign_define("DiagnosticSignHint",        { text = "🙋", texthl = "DiagnosticHint"        })
end

