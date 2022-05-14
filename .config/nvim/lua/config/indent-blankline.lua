vim.opt.list = true
vim.opt.listchars:append("eol:↴")

vim.g.indent_blankline_filetype_exclude = {
  'Regexplainer',
  'VGit',
  'alpha',
  'packer',
  'fugitive',
  'help',
  'neo-tree',
  'notify',
  'unix',
}

require 'indent_blankline'.setup {
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = false,
  show_end_of_line = true,
}
