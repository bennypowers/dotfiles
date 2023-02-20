return {
  root_dir = function() return require 'lspconfig.util'.find_git_ancestor() end,
  settings = {
    codeActionsOnSave = {
      enable = true,
      mode = 'all',
      rules = { '!debugger', '!no-only-tests/*' },
    },
  },
}

