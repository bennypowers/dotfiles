return { 'Iron-E/nvim-bufmode',
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
    au('ModeChanged', {
      group = ag('bufmodechanged', {}),
      callback = function(args)
        local prev, next = unpack(vim.split(args.match, ':'))
        if next == 'BUFFERS' or prev == 'BUFFERS' then
          require'buffertabs'.toggle()
        end
      end
    })
  end
}
