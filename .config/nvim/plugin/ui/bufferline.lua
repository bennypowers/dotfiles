local u = require'utils'
local command = vim.api.nvim_create_user_command
-- editor tabs. yeah ok I know they're not "tabs"
u.pack 'akinsho/bufferline.nvim'

require 'bufferline'.setup {
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
        filetype ~= 'trouble'
        and filename ~= '[No Name]'
        and filename ~= ''
      )
    end,
    hover = {
      enabled = true,
      delay = 200,
      reveal = { 'close' },
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
