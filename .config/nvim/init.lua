require 'impatient'

local function load(mod)
  package.loaded[mod] = nil
  return require(mod)
end

load 'options'
load 'format' -- Polyfill `vim.lsp.buf.format` from neovim 0.8
load 'plugins'
load 'commands'
load 'aucmds'
