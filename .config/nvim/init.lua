require 'impatient'

local function load(mod)
  package.loaded[mod] = nil
  return require(mod)
end

load 'options'
load 'commands'
load 'plugins'
load 'aucmds'

-- vim.cmd.colorscheme 'noctis'
-- vim.cmd.colorscheme 'leaf'
-- vim.cmd.colorscheme 'tokyonight'
vim.cmd.colorscheme 'catppuccin-mocha'
-- vim.cmd.colorscheme 'github_dark_default'
-- vim.g.oxocarbon_lua_transparent = true
-- vim.cmd.colorscheme 'oxocarbon-lua'

