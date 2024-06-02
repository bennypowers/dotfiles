return { 'Iron-E/nvim-bufmode',
  enabled = true,
  lazy = true,
  keys = {
    { 'gb', ':BufmodeEnter<cr>', desc = 'Enter Buffer Mode', },
    { 'B',  ':BufmodeEnter<cr>', desc = 'Enter Buffer Mode', },
  },
  dependencies = {'Iron-E/nvim-libmodal'},
  -- bufferline.nvim
  -- opts = {
  --   bufferline = true,
  --   keymaps = {
  --     ['<cr>'] = '<esc>',
  --     f = 'Telescope buffers',
  --     t = 'Neotree float buffers',
  --     d = 'BufDel',
  --     P = 'BufferLineTogglePin',
  --     e = 'BufferLineCycleNext',
  --     j = 'BufferLineCycleNext',
  --     k = 'BufferLineCyclePrev',
  --     E = 'BufferLineMoveNext',
  --   }
  -- },
  config = function()
    require'bufmode'.setup {
      bufferline = true,
      keymaps = {
        ['<cr>'] = '<esc>',
        B = '<esc>',
        f = 'Telescope buffers',
        t = 'Neotree float buffers',
        d = 'bdelete',
        l = 'bnext',
        j = 'bnext',
        k = 'bprev',
        h = 'bprev',
      }
    }
  end
}
