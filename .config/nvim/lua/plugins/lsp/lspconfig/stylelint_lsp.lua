local lsp_format = require 'lsp-format'
local lsp_status = require 'lsp-status'

-- stylelint_lsp
return {
  on_attach = function(client)
    lsp_format.on_attach(client)
    lsp_status.on_attach(client)
  end,
  filetypes = { 'css', 'scss' },
  settings = {
    stylelintplus = {
      autoFixOnSave = true,
      autoFixOnFormat = true,
      cssInJs = false,
    },
  },
}
