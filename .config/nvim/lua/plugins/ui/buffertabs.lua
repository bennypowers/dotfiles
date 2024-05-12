return { 'tomiis4/BufferTabs.nvim',
  enabled = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
  config = function()
    require'buffertabs'.setup {
      display = 'column',
      horizontal = 'right',
    }
    require'buffertabs'.toggle()
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
