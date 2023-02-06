-- multiple cursors, kinda like atom + vim-mode-plus
return { 'mg979/vim-visual-multi',
  branch = 'master',
  keys = {
    { '<c-n>', nil, mode = { 'n', 'v' } },
    { '<c-d>', '<Plug>(VM-Find-Subword-Under)<cr>', mode = 'v', desc = 'Find occurrence of subword under cursor' }
  },
}

