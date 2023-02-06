require'mappings.n'
require'mappings.i'
require'mappings.v'
require'mappings.t'

local U = require 'utils'

-- movement between windows
vim.keymap.set({ 'i', 't' }, '<A-h>', '<c-\\><c-N><c-w>h',  { desc='Move cursor to window left' })
vim.keymap.set({ 'i', 't' }, '<A-j>', '<c-\\><c-N><c-w>j',  { desc='Move cursor to window below' })
vim.keymap.set({ 'i', 't' }, '<A-k>', '<c-\\><c-N><c-w>k',  { desc='Move cursor to window above' })
vim.keymap.set({ 'i', 't' }, '<A-l>', '<c-\\><c-N><c-w>l',  { desc='Move cursor to window right' })
vim.keymap.set({ 'i', 't' }, '<A-p>', U.winpick,            { desc='Pick window'})
