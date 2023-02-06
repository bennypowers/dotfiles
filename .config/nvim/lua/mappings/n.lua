local function nmap(lhs, rhs, desc, opts)
  vim.keymap.set('n', lhs, rhs, vim.tbl_extend('force', opts or { }, { desc = desc }))
end

local U = require 'utils'

nmap('<c-l>',      '<cmd>ClearNotifications<cr>', 'Clear Notifications')

nmap('<m-i>',      U.refresh_init,                'Reload config')
nmap('E',          U.open_diagnostics,            'Open diagnostics in floating window')
nmap('<leader>e',  U.open_diagnostics,            'Open diagnostics in floating window')
nmap('<leader>le', U.open_diagnostics,            'Open diagnostics in floating window')
nmap('O',          U.open_uri_under_cursor,       'Open URI under cursor')
nmap('<leader>lf', U.format_file,                 'Format file')
nmap('gP',         U.close_all_win,               'Close all preview windows')

nmap('<A-h>', '<C-w>h',  'Move cursor to window left')
nmap('<A-j>', '<C-w>j',  'Move cursor to window below')
nmap('<A-k>', '<C-w>k',  'Move cursor to window above')
nmap('<A-l>', '<C-w>l',  'Move cursor to window right')
nmap('<A-p>', U.winpick, 'Pick window')

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

nmap('<leader>L',  ':Lazy<cr>',                   'Plugin manager')

