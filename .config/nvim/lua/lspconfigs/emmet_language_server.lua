return {
  root_dir = function() return require 'lspconfig.util'.find_git_ancestor() end,
  single_file_support = true,
  filetypes = {
    'html', 'webc',
    'svg',
    'css', 'scss',
    'markdown',
    'eruby',
    'nunjucks', 'njk', 'jinja',
    'typescript',
    'javascript',
  },
}

