return {
  root_dir = function() return require 'lspconfig.util'.find_git_ancestor() end,
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

