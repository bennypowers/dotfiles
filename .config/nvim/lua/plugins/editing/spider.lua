return { 'chrisgrieser/nvim-spider',
  lazy = true,
  enabled = false,
  keys = {
    {  'w', '<cmd>lua require"spider".motion"w"<cr>',  desc = 'Spider-w',  mode = {'n', 'o', 'x'} },
    {  'e', '<cmd>lua require"spider".motion"e"<cr>',  desc = 'Spider-e',  mode = {'n', 'o', 'x'} },
    {  'b', '<cmd>lua require"spider".motion"b"<cr>',  desc = 'Spider-b',  mode = {'n', 'o', 'x'} },
    { 'ge', '<cmd>lua require"spider".motion"ge"<cr>', desc = 'Spider-ge', mode = {'n', 'o', 'x'} },
  },
}
