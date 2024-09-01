return { 'rest-nvim/rest.nvim',
  enabled = true,
  ft = 'http',
  dependencies = { 'vhyrro/luarocks.nvim' },
  main = 'rest-nvim',
  keys = {
    { '<c-r>', ':Rest run<cr>', ft = 'http', desc = 'Run request under the cursor' },
  },
  opts = { }
}

