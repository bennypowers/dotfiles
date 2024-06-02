
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
  enabled = true,
  ft = filetypes,
  opts = {
    filetypes = filetypes
  }
}

