return { 'bennypowers/nvim-bufmode',
  dev = true,
  dependencies = {'Iron-E/nvim-libmodal'},
  opts = {
    bufferline = true,
    keymaps = {
      f = 'Telescope buffers',
      t = 'Neotree float buffers',
      d = 'BufDel',
      P = 'BufferLineTogglePin',
    }
  }
}
