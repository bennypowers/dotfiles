-- disables relative line numbers when appropriate
return { 'nkakouros-original/numbers.nvim',
  enabled = true,
  opts = {
    excluded_filetypes = {
      'Alpha',
      'alpha',
      'neo-tree',
      'neo-tree-popup',
      'oil',
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
