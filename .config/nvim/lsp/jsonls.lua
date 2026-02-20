---@type vim.lsp.Config
return {
  cmd = { 'vscode-json-language-server', '--stdio' },
  root_markers = { '.git' },
  filetypes = { 'json', 'jsonc' },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      format = { enable = true },
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
  -- on_attach = function(client, _) client.server_capabilities.hoverProvider = false end,
}
