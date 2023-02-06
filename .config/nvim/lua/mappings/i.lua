local function imap(lhs, rhs, desc)
  vim.keymap.set('i', lhs, rhs, { desc = desc })
end

imap('<c-l>', '<cmd>ClearNotifications<cr>', 'Clear Notifications')
