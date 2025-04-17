local cfg = require'lsp'

---@type vim.lsp.ClientConfig
return {
  cmd = { 'design-tokens-language-server' },
  root_markers = { '.git' },
  filetypes = { 'css' },
  on_attach = function(client, bufnr)
    cfg.on_attach(client, bufnr)
    require'document-color'.on_attach(client, bufnr)
  end,
}

