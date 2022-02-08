return function()
  local bufferline = require'bufferline'
  vim.cmd 'source ~/.config/nvim/config/bbye.vim'
  bufferline.setup {
    options = {
      numbers = 'none',
      diagnostics = 'nvim_lsp',
      show_buffer_icons = true,
      show_close_icon = true,
      custom_filter = function(bufnr)
        local filetype = vim.bo[bufnr].filetype
        local filename = vim.fn.bufname(bufnr)
        return (
              filetype ~= 'neo-tree'
          and filetype ~= 'Trouble'
          and filename ~= 'neo-tree filesystem [1]'
          and filename ~= '[No Name]'
        )
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text_align = "center",
          highlight = 'Directory',
          text = 'Files',
          -- text = function() return vim.fn.getcwd() end,
        },
      },
    },
  }
end
