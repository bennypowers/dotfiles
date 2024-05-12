
-- autoconvert '' or "" to ``
local filetypes = {
  'html',
  'javascript',
  'typescript',
  -- 'javascriptreact',
  -- 'typescriptreact',
  'python',
}

return { 'axelvc/template-string.nvim',
  ft = filetypes,
  opts = {
    filetypes = filetypes
  }
}

