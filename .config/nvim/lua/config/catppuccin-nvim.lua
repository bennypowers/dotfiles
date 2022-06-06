local catppuccin = require 'catppuccin'
catppuccin.setup {
  transparent_background = true,
  integrations = {
    lsp_trouble = true,
    neotree = {
      enabled = true,
      show_root = true,
      transparent_panel = true,
    },
    which_key = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
  }
}

vim.g.catppuccin_flavour = 'mocha' -- latte, frappe, macchiato, mocha
vim.cmd [[colorscheme catppuccin]]
