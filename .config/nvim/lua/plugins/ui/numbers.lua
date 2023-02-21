-- disables relative line numbers when appropriate
return { 'nkakouros-original/numbers.nvim',
  opts = {
    excluded_filetypes = {
      'Alpha',
      'alpha',
      'neo-tree',
      'neo-tree-popup',
      'DressingInput',
      'terminal',
      'Terminal',
      '',
      'mason',
      'lazy',
      'packer',
      'toggleterm',
      'Telescope',
      'TelescopePrompt',
    },
  },
}
