require 'nvim-surround'.buffer_setup {
  delimiters = {
    pairs = {
      ["["] = { "[", "]()" },
    },
  }
}

vim.bo.formatoptions = 'tacqw'
vim.bo.textwidth = 80
vim.bo.wrapmargin = 0
vim.bo.autoindent = true
