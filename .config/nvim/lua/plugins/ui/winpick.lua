local function winpick()
  require 'winpick'.select()
end

return { 'gbrlsnchs/winpick.nvim',
  enabled = true,
  lazy = true,
  keys = {
    { '<leader>w', winpick, desc = 'Pick window', mode = { 'n' } },
    { '<c-w>', winpick, desc = 'Pick window', mode = { 't' } },
  },
  opts = {},
}
