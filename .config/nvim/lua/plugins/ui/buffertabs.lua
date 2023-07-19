return { 'tomiis4/BufferTabs.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
  config = function()
    require'buffertabs'.setup {
      display = 'column',
      horizontal = 'right',
    }
    require'buffertabs'.toggle()
  end
}
