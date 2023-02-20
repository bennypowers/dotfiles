return { 'Iron-E/nvim-bufmode',
  lazy = true,
  keys = {
    { 'gb', ':BufmodeEnter<cr>', desc = 'Enter Buffer Mode', },
    { 'B',  ':BufmodeEnter<cr>', desc = 'Enter Buffer Mode', },
  },
  dependencies = {'Iron-E/nvim-libmodal'},
  opts = {
    bufferline = true,
    keymaps = {
      ['<cr>'] = '<esc>',
      f = 'Telescope buffers',
      t = 'Neotree float buffers',
      d = 'BufDel',
      P = 'BufferLineTogglePin',
      e = 'BufferLineCycleNext',
      j = 'BufferLineCycleNext',
      k = 'BufferLineCyclePrev',
      E = 'BufferLineMoveNext',
    }
  }
}
