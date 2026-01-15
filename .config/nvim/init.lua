-- globals
command = vim.api.nvim_create_user_command
ag = vim.api.nvim_create_augroup
au = vim.api.nvim_create_autocmd

require 'options'
require 'commands'
require 'aucmds'
require 'mappings'

require('lazy').setup('plugins', {
  dev = {
    path = '~/Developer',
    patterns = { 'bennypowers' },
    fallback = true,
  },
  performance = {
    rtp = {
      paths = { '/usr/share/vim/vimfiles/' },
    },
  },
})
