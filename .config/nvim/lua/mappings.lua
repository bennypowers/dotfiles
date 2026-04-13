local u = require'utils'

local function format_async() vim.lsp.buf.format { async = true } end
local function open_diagnostics() vim.diagnostic.open_float { focus = false } end

-- put without yanking
u.nmap('<c-p>', '"_dP')
u.vmap('<c-p>', '"_dP')
-- yank to system clipboard
u.nmap('<c-y>', '"+y')
u.vmap('<c-y>', '"+y')

u.nmap('<S-k>', vim.lsp.buf.hover, 'Hover')
u.nmap('<c-l>', '<cmd>ClearNotifications<cr>', 'Clear Notifications')

-- movement between windows
u.nmap('<A-h>', '<C-w>h', 'Move cursor to window left')
u.nmap('<A-j>', '<C-w>j', 'Move cursor to window below')
u.nmap('<A-k>', '<C-w>k', 'Move cursor to window above')
u.nmap('<A-l>', '<C-w>l', 'Move cursor to window right')
u.map('<A-h>', '<c-\\><c-N><c-w>h', 'Move cursor to window left', { mode = { 'i', 't' } })
u.map('<A-j>', '<c-\\><c-N><c-w>j', 'Move cursor to window below', { mode = { 'i', 't' } })
u.map('<A-k>', '<c-\\><c-N><c-w>k', 'Move cursor to window above', { mode = { 'i', 't' } })
u.map('<A-l>', '<c-\\><c-N><c-w>l', 'Move cursor to window right', { mode = { 'i', 't' } })

u.nmap('<leader>e', open_diagnostics, 'Open diagnostics in floating window')
u.nmap('<leader>lf', format_async, 'Format file')

u.nmap('grD', vim.lsp.buf.declaration, 'Go to declaration')
u.nmap('gdr', vim.lsp.buf.definition, 'Go to definitions')
u.nmap('grt', vim.lsp.buf.type_definition, 'Go to type definition')
