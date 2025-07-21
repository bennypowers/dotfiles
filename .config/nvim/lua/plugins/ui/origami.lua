return { 'chrisgrieser/nvim-origami',
  opts = {
    foldtext = {
      enabled = true,
      padding = 1,
      lineCount = {
        template = " (:%d)",
      },
    },
  },
  init = function()
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
  end,
}
