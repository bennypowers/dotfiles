-- indent guide
return { 'lukas-reineke/indent-blankline.nvim',
  enabled = false,
  lazy = true,
  version = '*',
  event = 'CursorMoved',
  main = 'ibl',
  opts = {
    indent = {
      -- enabled = true,
      -- char = ' ',
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = true,
    },
    whitespace = {
      remove_blankline_trail = true,
    },
    exclude = {
      filetypes = {
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
        'dressing',
      },
    },
  },
}
