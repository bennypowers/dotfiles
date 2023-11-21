return { 'mrjones2014/legendary.nvim',
  lazy = false,
  priority = 10000,
  keys = {
    { '<leader>k',  ':Legendary<cr>', desc = 'Command Palette' },
  },
  opts = {
    extensions = {
      lazy_nvim = {
        auto_register = true,
      },
    },
  },
}
