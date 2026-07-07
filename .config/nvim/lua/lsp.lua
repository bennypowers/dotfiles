vim.lsp.handlers['window/showMessage'] = function(_, result)
  vim.notify(
    vim.inspect(result),
    ({
      vim.log.levels.ERROR,
      vim.log.levels.WARN,
      vim.log.levels.INFO,
      vim.log.levels.DEBUG,
      vim.log.levels.TRACE,
    })[result.type]
  )
end

vim.lsp.enable {
  'asimonim',
  'bashls',
  'cem',
  'cssls',
  'denols',
  'emmet_language_server',
  'eslint',
  'fish_lsp',
  'fsautocomplete',
  'golangci-lint-langserver',
  'gopls',
  'html',
  'hyprls',
  'jsonls',
  'lua_ls',
  'marksman',
  'qmlls',
  'rust_analyzer',
  'stylelint_lsp',
  'termux-language-server',
  'vtsls',
  'yamlls',
}
