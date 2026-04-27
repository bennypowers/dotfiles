---markdown marksman language server
---@type vim.lsp.ClientConfig
return {
  cmd = { vim.fn.executable(vim.env.HOME .. '/.local/bin/marksman') == 1
  and vim.env.HOME .. '/.local/bin/marksman'
  or 'marksman', 'server' },
  filetypes = { 'markdown' },
  root_markers = { '.marksman.toml', '.git' },
  settings = {
    autoFixOnSave = true,
  },
}
