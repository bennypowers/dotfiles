local bufferline = require 'bufferline'
local U = require 'utils'

bufferline.setup {
  options = {
    separator_style = 'slant',
    numbers = 'none',
    diagnostics = 'nvim_lsp',
    show_buffer_icons = true,
    show_close_icon = true,
    right_mouse_command = U.bufdelete,
    close_command = U.bufdelete,
    custom_filter = function(bufnr)
      local filetype = vim.bo[bufnr].filetype
      local filename = vim.fn.bufname(bufnr)
      return (
          filetype ~= 'neo-tree'
              and filetype ~= 'Trouble'
              and filename ~= 'neo-tree filesystem [1]'
              and filename ~= '[No Name]'
              and filename ~= ''
          )
    end,
    offsets = {
      {
        filetype = "neo-tree",
        text_align = "center",
        highlight = 'Directory',
        text = 'Files',
      },
    },
  },

}
