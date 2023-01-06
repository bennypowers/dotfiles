-- bootstrap plugins
local lazypath = vim.fn.stdpath'data'..'/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system{
    'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require 'options'
require 'commands'
require 'aucmds'
require'lazy'.setup'plugins'

vim.cmd.colorscheme
  'catppuccin-mocha'
  -- 'noctis'
  -- 'leaf'
  -- 'tokyonight'
  -- 'github_dark_default'
  -- 'oxocarbon-lua'

