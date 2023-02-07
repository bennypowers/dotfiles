-- disables relative line numbers when appropriate
return { 'nkakouros-original/numbers.nvim',
  opts = {
    excluded_filetypes = {
      'neo-tree',
      'neo-tree-popup',
      'DressingInput',
      'terminal',
      'packer',
      'toggleterm',
      'Telescope',
      'TelescopePrompt',
    },
  },
}
