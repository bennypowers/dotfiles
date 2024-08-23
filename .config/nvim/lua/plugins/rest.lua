return { 'rest-nvim/rest.nvim',
  enabled = true,
  ft = 'http',
  dependencies = { 'vhyrro/luarocks.nvim' },
  main = 'rest-nvim',
  keys = {
    { '<c-r>', ':Rest run<cr>', 'Run request under the cursor' },
  },
  opts = { }
}

