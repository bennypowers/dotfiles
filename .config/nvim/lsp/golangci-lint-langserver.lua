---@type vim.lsp.ClientConfig
return {
  cmd = { 'golangci-lint-langserver' },
  filetypes = { 'go', 'gomod' },
  root_markers = {
    'go.mod',
  },
  init_options = {
    command = {
      'golangci-lint',
      'run',
      '--output.json.path',
      'stdout',
      '--show-stats=false',
      '--issues-exit-code=1',
    },
  },
}
