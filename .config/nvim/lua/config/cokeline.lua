return function()
  require'cokeline'.setup {
    filter_visible = function (buffer)
      return buffer.filename ~= 'neo-tree filesystem [1]'
    end,
    rendering = {
      left_sidebar = {
        filetype = 'neo-tree',
        components = {
          {
            text = 'Files',
            delete_buffer_on_left_click = false,
            hl = { fg = 'red' },
          },
        },
      },
    },
  }
end
