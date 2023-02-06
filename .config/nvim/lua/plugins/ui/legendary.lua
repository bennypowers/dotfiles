local function toggle_inlayhints()
  require'lsp-inlayhints'.toggle()
end

local function legendary_open()
  require 'legendary'.find()
end

return { 'mrjones2014/legendary.nvim',
  name = 'legendary',
  lazy = true,
  keys = {
    { '<leader>k',  legendary_open, desc = 'Command Palette' },
  },
  opts = {
    include_builtin = true,
    select_prompt = 'Command Pallete',
    which_key = {
      auto_register = true,
    },
    commands = {
      { ':GHOpenPR<cr>', description = 'GitHub Open PR' },
      { ':GHClosePR<cr>', description = 'GitHub Close PR' },
      { ':GHAddLabel<cr>', description = 'GitHub Add Label' },
      { ':ToggleInlayHints', toggle_inlayhints, description = 'Toggle Inlay Hints' },
    },
  },
}
