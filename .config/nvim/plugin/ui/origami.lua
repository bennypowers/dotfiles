local u = require'utils'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

u.pack('chrisgrieser/nvim-origami')

require'origami'.setup{
  foldtext = {
    enabled = true,
    padding = {
      character = ' ',
      width = 1,
    },
    lineCount = {
      template = ' (:%d)',
    },
  },
  foldKeymaps = {
    setup = true, -- modifies `h`, `l`, and `$`
    closeOnlyOnFirstColumn = true,
  },
}

vim.keymap.set('n', 'h', 'h') -- restore default, disable fold-close
