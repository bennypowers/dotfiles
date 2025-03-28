-- Plugin mappings are typically in their own plugin definition files
-- see lua/plugins/*/*.lua
--

--- Wrapper for vim.keymap.set
local function map(lhs, rhs, desc, opts)
  local options = { desc = desc }
  for k, v in ipairs(opts or {}) do
    options[k] = v
  end
  vim.keymap.set(opts.mode, lhs, rhs, options)
end

local function nmap(lhs, rhs, desc) map(lhs, rhs, desc, { mode = 'n' }) end
local function vmap(lhs, rhs, desc) map(lhs, rhs, desc, { mode = 'v' }) end
local function imap(lhs, rhs, desc) map(lhs, rhs, desc, { mode = 'i' }) end

local function format_async() vim.lsp.buf.format { async = true } end
local function open_diagnostics() vim.diagnostic.open_float { focus = false } end

-- put without yanking
nmap('<c-p>',      '"_dP')
vmap('<c-p>',      '"_dP')
-- yank to system clipboard
nmap('<c-y>',      '"+y')
vmap('<c-y>',      '"+y')

nmap('<leader>L',  ':Lazy<cr>',                   'Plugin manager')
nmap('<c-l>',      '<cmd>ClearNotifications<cr>', 'Clear Notifications')

-- movement between windows
nmap('<A-h>',      '<C-w>h',                      'Move cursor to window left')
nmap('<A-j>',      '<C-w>j',                      'Move cursor to window below')
nmap('<A-k>',      '<C-w>k',                      'Move cursor to window above')
nmap('<A-l>',      '<C-w>l',                      'Move cursor to window right')
map('<A-h>',       '<c-\\><c-N><c-w>h',           'Move cursor to window left' ,  { mode = { 'i', 't' } })
map('<A-j>',       '<c-\\><c-N><c-w>j',           'Move cursor to window below' , { mode = { 'i', 't' } })
map('<A-k>',       '<c-\\><c-N><c-w>k',           'Move cursor to window above' , { mode = { 'i', 't' } })
map('<A-l>',       '<c-\\><c-N><c-w>l',           'Move cursor to window right' , { mode = { 'i', 't' } })

nmap('<leader>e',  open_diagnostics,              'Open diagnostics in floating window')
nmap('<leader>lf', format_async,                  'Format file')

nmap('grD',         vim.lsp.buf.declaration,       'Go to declaration')
nmap('gdr',         vim.lsp.buf.definition,        'Go to definitions')
nmap('grt',        vim.lsp.buf.type_definition,   'Go to type definition')
