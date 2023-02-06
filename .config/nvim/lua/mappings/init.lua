require'mappings.n'
require'mappings.i'
require'mappings.v'
require'mappings.t'

local U = require 'utils'

-- movement between windows
for _,mode in ipairs({ 'n', 'i', 't', 'v' }) do
  vim.keymap.set(mode, '<m-h>', '<C-w>h',  {desc='Move cursor to window left'})
  vim.keymap.set(mode, '<m-j>', '<C-w>j',  {desc='Move cursor to window below'})
  vim.keymap.set(mode, '<m-k>', '<C-w>k',  {desc='Move cursor to window above'})
  vim.keymap.set(mode, '<m-l>', '<C-w>l',  {desc='Move cursor to window right'})
  vim.keymap.set(mode, '<m-p>', U.winpick, {desc='Pick window'})
end

