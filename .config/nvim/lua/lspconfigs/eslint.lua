return {
  -- root_dir = function() return require 'lspconfig.util'.find_git_ancestor() end,
  on_attach = function(client)
    require 'lsp-format'.on_attach(client)
    require 'lsp-status'.on_attach(client)
  end,
  settings = {
    codeActionsOnSave = {
      enable = true,
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
