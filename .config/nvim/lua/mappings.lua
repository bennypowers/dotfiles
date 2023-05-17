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

nmap('<leader>L',  ':Lazy<cr>',                   'Plugin manager')
nmap('<c-l>',      '<cmd>ClearNotifications<cr>', 'Clear Notifications')

nmap('<A-h>',      '<C-w>h',                      'Move cursor to window left')
nmap('<A-j>',      '<C-w>j',                      'Move cursor to window below')
nmap('<A-k>',      '<C-w>k',                      'Move cursor to window above')
nmap('<A-l>',      '<C-w>l',                      'Move cursor to window right')

nmap('<leader>e',  open_diagnostics,            'Open diagnostics in floating window')
nmap('<leader>lf', format_async,                  'Format file')

nmap('K',          vim.lsp.buf.hover,             'Hover')
nmap('<leader>.',  vim.lsp.buf.code_action,       'Code actions')
nmap('<c-k>',      vim.lsp.buf.signature_help,    'Signature help')
nmap('<leader>lr', vim.lsp.buf.rename,            'Rename')
nmap('<leader>lk', vim.lsp.buf.signature_help,    'Signature help')
nmap('<leader>ld', vim.lsp.buf.declaration,       'Go to declaration')
nmap('<leader>lD', vim.lsp.buf.type_definition,   'Go to type definition')
nmap('gD',         vim.lsp.buf.declaration,       'Go to declaration')
nmap('gd',         vim.lsp.buf.definition,        'Go to definitions')
nmap('gtd',        vim.lsp.buf.type_definition,   'Go to type definition')
nmap('gi',         vim.lsp.buf.implementation,    'Go to implementations')
nmap('gr',         vim.lsp.buf.references,        'Go to references')

nmap('<m-,>',      vim.diagnostic.goto_prev,      'Previous diagnostic')
nmap('<m-.>',      vim.diagnostic.goto_next,      'Next diagnostic')

-- movement between windows
map('<A-h>',       '<c-\\><c-N><c-w>h',           'Move cursor to window left' ,  { mode = { 'i', 't' } })
map('<A-j>',       '<c-\\><c-N><c-w>j',           'Move cursor to window below' , { mode = { 'i', 't' } })
map('<A-k>',       '<c-\\><c-N><c-w>k',           'Move cursor to window above' , { mode = { 'i', 't' } })
map('<A-l>',       '<c-\\><c-N><c-w>l',           'Move cursor to window right' , { mode = { 'i', 't' } })

vmap('rn',         vim.lsp.buf.rename,            'Rename refactor')

imap('<c-l>',      '<cmd>ClearNotifications<cr>', 'Clear Notifications')
