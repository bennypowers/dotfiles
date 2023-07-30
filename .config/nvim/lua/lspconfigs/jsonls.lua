return {
  on_attach = function(client)
    -- require 'lsp-format'.on_attach(client)
    require 'lsp-status'.on_attach(client)
  end,
  settings = {
    json = {
      format = { enable = true },
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
}

