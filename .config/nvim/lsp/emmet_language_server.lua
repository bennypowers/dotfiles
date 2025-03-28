---@type vim.lsp.ClientConfig
return {
  cmd = { 'emmet-language-server', '--stdio' },
  root_markers = {'.git'},
  filetypes = {
    'html',
    'htmlangular',
    'htmldjango',
    'css',
    'eruby',
    'javascript',
    'javascriptreact',
    'jinja',
    'less',
    'markdown',
    'njk',
    'nunjucks',
    'pug',
    'sass',
    'scss',
    'scss',
    'svg',
    'typescript',
    'typescriptreact',
    'webc',
  },
}

