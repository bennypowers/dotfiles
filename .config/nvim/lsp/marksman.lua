---markdown marksman language server
---@type vim.lsp.ClientConfig
return {
  cmd = { 'marksman', 'server' },
  filetypes = { 'markdown', 'markdown.mdx' },
  root_markers = { '.marksman.toml', '.git' },
  settings = {
    autoFixOnSave = true,
  },
}
