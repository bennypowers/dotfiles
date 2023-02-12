return { 'mhartington/formatter.nvim',
  config = function()
    require('formatter').setup {
      filetype = {
        -- lua = require'formatter.filetypes.lua'.stylua,
        javascript = function() vim.cmd [[:EslintFixAll]] end,
        typescript = function() vim.cmd [[:EslintFixAll]] end,
      },
    }
    au('BufWritePost', {
      group = ag('FormatAutogroup', {}),
      pattern = '*',
      command = 'FormatWrite',
    })
  end,
}
