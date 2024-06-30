-- like vmp `g,` action
return { 'bennypowers/splitjoin.nvim',
  enabled = true,
  lazy = true,
  keys = {
    { 'gj', function() require'splitjoin'.join() end, desc = 'Join the object under cursor' },
    { 'g,', function() require'splitjoin'.split() end, desc = 'Split the object under cursor' },
  },
  opts = {
    languages = {
      html = {
        nodes = {
          attribute = {
            aligned = true,
          },
        },
      },
    },
  },
}
