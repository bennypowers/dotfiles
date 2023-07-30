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
    local format_on_save = true
    command('FormatDisable', function()
      format_on_save = false
    end, {
      desc = 'Disable format on save',
    })
    command('FormatEnable', function()
      format_on_save = true
    end, {
      desc = 'Enable format on save',
    })
    au('BufWritePost', {
      group = ag('FormatAutogroup', {}),
      pattern = '*',
      callback = function(args)
        if format_on_save and vim.fn.match(ignores, args.file) ~= -1 then
          vim.cmd[[FormatWrite]]
        end
      end
    })
  end,
}
