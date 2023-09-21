local function wrap_with_abbreviation (...) require'nvim-emmet'.wrap_with_abbreviation(...) end

return { 'olrtg/nvim-emmet',
  ft = {
    'html', 'webc', 'svg',
    'css', 'scss',
    'njk', 'nunjucks', 'jinja',
    'md', 'markdown',
    'ts', 'typescript', 'typescriptreact',
    'js', 'javascript', 'javascriptreact',
  },
  -- opts = {},
  keys = {
    { '<leader>xe', wrap_with_abbreviation, mode = { "n", "v" }, desc = "Emmet: Wrap with abbreviation" }
  },
}
