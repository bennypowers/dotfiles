local ignores = {
  'nusah/keymap.json'
}

return { 'mhartington/formatter.nvim',
  config = function()
    require('formatter').setup {
      filetype = {
        -- lua = require'formatter.filetypes.lua'.stylua,
        javascript = require'formatter.filetypes.javascript'.eslint_d,
        typescript = require'formatter.filetypes.typescript'.eslint_d,
        json = require'formatter.filetypes.json'.fixjson,
      },
    }
    au('BufWritePost', {
      group = ag('FormatAutogroup', {}),
      pattern = '*',
      callback = function(args)
        if vim.fn.match(ignores, args.file) ~= -1 then
          vim.cmd[[FormatWrite]]
        end
      end
    })
  end,
}
