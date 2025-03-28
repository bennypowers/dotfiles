local cfg = require 'lsp'

---@type vim.lsp.ClientConfig
return {
  on_attach = cfg.on_attach,
  cmd = { 'vscode-json-language-server', '--stdio' },
  root_markers = { '.git' },
  filetypes = { 'json', 'jsonc' },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      format = { enable = true },
      schemas = require 'schemastore'.json.schemas(),
      validate = { enable = true },
    },
  },
}
