local lsp_util = require 'lspconfig.util'
return {
  root_dir = lsp_util.find_git_ancestor,
  single_file_support = true,
  filetypes = {
    'html',
    'svg',
    'css',
    'scss',
    'njk',
    'nunjucks',
    'jinja',
    -- 'markdown',
    'ts',
    'typescript',
    'js',
    'javascript',
  },
}

