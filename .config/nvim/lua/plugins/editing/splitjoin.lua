-- like vmp `g,` action
return { 'AndrewRadev/splitjoin.vim', keys = { 'gj', 'g,' }, init = function()

vim.g.splitjoin_split_mapping = ''
vim.g.splitjoin_join_mapping = ''
vim.api.nvim_set_keymap('n', 'gj', ':SplitjoinJoin<cr>', {})
vim.api.nvim_set_keymap('n', 'g,', ':SplitjoinSplit<cr>', {})

end }
