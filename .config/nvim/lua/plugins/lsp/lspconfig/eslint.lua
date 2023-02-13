local lsp_util = require 'lspconfig.util'

return {
  root_dir = lsp_util.find_git_ancestor,
  settings = {
    codeActionsOnSave = {
      enable = true,
      mode = 'all',
      rules = { '!debugger', '!no-only-tests/*' },
    },
  },
}

