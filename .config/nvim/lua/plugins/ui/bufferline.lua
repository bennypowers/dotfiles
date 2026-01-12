-- editor tabs. yeah ok I know they're not "tabs"
return {
  'akinsho/bufferline.nvim',
  version = 'v4.*',
  enabled = true,
  lazy = true,
  event = 'ColorScheme',
  dependencies = { 'catppuccin/nvim' },
  config = function()
    require('bufferline').setup {
      highlights = require('catppuccin.special.bufferline').get_theme(),
      options = {
        separator_style = 'slope',
        diagnostics = 'nvim_lsp',
        show_buffer_icons = true,
        -- show_close_icon = true,
        middle_mouse_command = 'bdelete! %d',
        close_command = 'bdelete! %d',
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
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' },
        },
        offsets = {
          {
            filetype = 'neo-tree',
            text_align = 'center',
            highlight = 'BufferlineFill',
            text = function() return vim.fn.getcwd() end,
          },
        },
      },
    }
    command('BufferlineCloseOthers', function(args)
      if args.bang then
        vim.cmd [[
          :BufferLineCloseLeft!
          :BufferLineCloseRight!
        ]]
      else
        vim.cmd [[
          :BufferLineCloseLeft
          :BufferLineCloseRight
        ]]
      end
    end, { desc = 'Close unfocused listed buffers' })
  end,
}
