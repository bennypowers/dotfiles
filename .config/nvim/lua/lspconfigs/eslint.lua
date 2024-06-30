return {
  -- root_dir = function() return require 'lspconfig.util'.find_git_ancestor() end,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    require 'lsp-format'.on_attach(client, bufnr)
    require 'lsp-status'.on_attach(client, bufnr)
  end,
  settings = {
    format = {
      enable = true,
    },
    codeActionsOnSave = {
      mode = 'all',
      rules = { '!debugger', '!no-only-tests/*' },
    },
  },
  filetypes = {
    'javascript', 'javascriptreact',
    'typescript', 'typescriptreact',
    'html',
  }
}
