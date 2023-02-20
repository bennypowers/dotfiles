local lsp_status = require 'lsp-status'
local lsp_format = require 'lsp-format'

return {
  on_attach = function(client)
    lsp_format.on_attach(client)
    lsp_status.on_attach(client)
  end,
  settings = {
    json = {
      format = { enable = true },
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
}

