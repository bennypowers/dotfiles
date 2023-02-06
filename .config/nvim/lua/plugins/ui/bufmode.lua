return { 'bennypowers/nvim-bufmode',
  dev = true,
  lazy = true,
  keys = {
    { 'gb', ':BufmodeEnter<cr>', desc = 'Enter Buffer Mode', },
    { 'B',  ':BufmodeEnter<cr>', desc = 'Enter Buffer Mode', },
  },
  dependencies = {'Iron-E/nvim-libmodal'},
  opts = {
    bufferline = true,
    keymaps = {
      f = 'Telescope buffers',
      t = 'Neotree float buffers',
      d = 'BufDel',
      P = 'BufferLineTogglePin',
      e = 'BufferLineCycleNext',
      E = 'BufferLineMoveNext',
    }
  }
}
