local function toggle_inlayhints()
  require'lsp-inlayhints'.toggle()
end

local function legendary_open()
  require 'legendary'.find({})
end

return { 'mrjones2014/legendary.nvim',
  lazy = false,
  priority = 10000,
  keys = {
    { '<leader>k',  legendary_open, desc = 'Command Palette' },
  },
  opts = { lazy_nvim = { auto_register = true } },
}
