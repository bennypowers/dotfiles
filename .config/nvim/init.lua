require 'impatient'

local function load(mod)
  package.loaded[mod] = nil
  return require(mod)
end

-- Polyfill `vim.lsp.buf.format` from neovim 0.8
if vim.fn.has 'nvim-0.8.0' == 0 then load 'format' end
load 'options'
load 'commands'
load 'plugins'
load 'aucmds'
