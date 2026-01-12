return {
  'chrisgrieser/nvim-origami',
  opts = {
    foldtext = {
      enabled = true,
      padding = 1,
      lineCount = {
        template = ' (:%d)',
      },
    },
    foldKeymaps = {
      setup = true, -- modifies `h`, `l`, and `$`
      hOnlyOpensOnFirstColumn = true,
    },
  },
  init = function()
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
  end,
}
