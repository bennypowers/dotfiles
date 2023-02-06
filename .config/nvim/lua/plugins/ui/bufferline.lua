-- editor tabs. yeah ok I know they're not "tabs"
return { 'akinsho/bufferline.nvim',
  version = "v2.*",
  lazy = true,
  event = 'ColorScheme',
  dependencies = {'catppuccin/nvim'},
  config = function ()
    require 'bufferline'.setup {
      highlights = require'catppuccin.groups.integrations.bufferline'.get(),
      options = {
        separator_style = 'slant',
        numbers = 'none',
        diagnostics = 'nvim_lsp',
        show_buffer_icons = true,
        show_close_icon = true,
        right_mouse_command = 'bdelete',
        close_command = 'bdelete',
        custom_filter = function(bufnr)
          local filetype = vim.bo[bufnr].filetype
          local filename = vim.fn.bufname(bufnr)
          return ( filetype ~= 'neo-tree'
               and filetype ~= 'Trouble'
               and filename ~= 'neo-tree filesystem [1]'
               and filename ~= '[No Name]'
               and filename ~= '' )
        end,
        hover = {
          enabled = true,
          delay = 200,
          reveal = {'close'},
        },
        offsets = {
          {
            filetype = "neo-tree",
            text_align = "center",
            highlight = 'BufferlineFill',
            text = function()
              return vim.fn.getcwd()
            end,
          },
        },
      },
    }
  end

}

