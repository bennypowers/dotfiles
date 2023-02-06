return { 'gbrlsnchs/winpick.nvim',
  lazy = true,
  keys = {
    { ';p', function () require 'winpick'.select() end, desc = 'Pick window', mode = { 'i', 't' } },
  },
  opts = {},
}
