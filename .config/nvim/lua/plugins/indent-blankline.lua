-- indent guide
return { 'lukas-reineke/indent-blankline.nvim', config = function()

require 'indent_blankline'.setup {
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = false,
  show_end_of_line = true,
  filetype_exclude = {
    'Regexplainer',
    'VGit',
    'alpha',
    'Alpha',
    'dashboard',
    'packer',
    'fugitive',
    'help',
    'neo-tree',
    'notify',
    'unix',
  }
}

end }
