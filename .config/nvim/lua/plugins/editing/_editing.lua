return {

  -- close buffers (tabs) with less headache
  'ojroques/nvim-bufdel',

  -- multiple cursors, kinda like atom + vim-mode-plus
  { 'mg979/vim-visual-multi', branch = 'master', keys = { '<c-n>' } },

  -- gs to toggle bool
  'AndrewRadev/switch.vim',

  -- better vim marks
  { 'chentau/marks.nvim', enabled = false },

  -- align anything
  'tommcdo/vim-lion',

  -- autoconvert '' or "" to ``
  'axelvc/template-string.nvim',

  -- yae, cae, etc
  { 'kana/vim-textobj-entire', dependencies = { 'kana/vim-textobj-user' } },

  -- convert colour values
  { 'NTBBloodbath/color-converter.nvim', enabled = false },

}
