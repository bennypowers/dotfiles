return { 'nkakouros-original/numbers.nvim', config = function()

require 'numbers'.setup {
  excluded_filetypes = {
    'neo-tree',
    'terminal',
    'packer',
    'toggleterm',
    'DressingInput',
    'Telescope',
    'TelescopePrompt',
  }
}

end }
