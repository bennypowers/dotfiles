require 'impatient'

local function load(mod)
  package.loaded[mod] = nil
  return require(mod)
end

load 'options'
load 'commands'
load 'plugins'
load 'aucmds'

vim.cmd.colorscheme
  'catppuccin-mocha'
  -- 'noctis'
  -- 'leaf'
  -- 'tokyonight'
  -- 'github_dark_default'
  -- 'oxocarbon-lua'

