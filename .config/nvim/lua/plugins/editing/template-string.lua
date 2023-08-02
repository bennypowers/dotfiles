
-- autoconvert '' or "" to ``
local filetypes = {
  'html',
  'javascript',
  'typescript',
  'javascriptreact',
  'typescriptreact',
  'python',
}

return { 'axelvc/template-string.nvim',
  filetypes = filetypes,
  opts = {
    filetypes = filetypes
  }
}

