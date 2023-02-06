vim.g.splitjoin_split_mapping = ''
vim.g.splitjoin_join_mapping = ''

-- like vmp `g,` action
return { 'AndrewRadev/splitjoin.vim',
  lazy = true,
  keys = {
    { 'gj', ':SplitjoinJoin<cr>', desc = 'Join the object under cursor' },
    { 'g,', ':SplitjoinSplit<cr>', desc = 'Split the object under cursor' },
  },
  cmd = { 'SplitjoinJoin', 'SplitjoinSplit' },
}
