---@type vim.lsp.ClientConfig
return {
  cmd = { 'emmet-language-server', '--stdio' },
  root_markers = { '.git' },
  filetypes = {
    'html',
    'htmlangular',
    'htmldjango',
    'css',
    'eruby',
    'javascript',
    'javascriptreact',
    'handlebars',
    'jinja',
    'less',
    'markdown',
    'sass',
    'scss',
    'svg',
    'typescript',
    'typescriptreact',
    'webc',
  },
  init_options = {
    showExpandedAbbreviation = 'always',
    showSuggestionsAsSnippets = true,
  },
}
