-- disables relative line numbers when appropriate
return { 'nkakouros-original/numbers.nvim', config = function()

require 'numbers'.setup {
  excluded_filetypes = {
    'neo-tree',
    'neo-tree-popup',
    'DressingInput',
    'terminal',
    'packer',
    'toggleterm',
    'Telescope',
    'TelescopePrompt',
  }
}

end }
