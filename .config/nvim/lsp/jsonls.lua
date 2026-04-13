local u = require'utils'
u.pack('b0o/schemastore.nvim') -- json schema support

local schemastore = require 'schemastore'

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
      schemas = schemastore.json.schemas(),
      validate = { enable = true },
    },
  },
}
