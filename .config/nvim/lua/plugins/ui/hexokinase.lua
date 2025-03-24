-- display colour values
return { 'RRethy/vim-hexokinase',
  enabled = false,
  build = 'make hexokinase',
  cmd = { 'HexokinaseToggle', 'HexokinaseTurnOn' },
  init = function()

    vim.g.Hexokinase_ftOptOutPatterns = {
      json = { 'colour_names' },
      yaml = { 'colour_names' },
    }

    vim.g.Hexokinase_palettes = {
      vim.fn.expand('~/Developer/redhat-ux/red-hat-design-tokens/editor/neovim/hexokinase-vars.json'),
      vim.fn.expand('~/Developer/redhat-ux/red-hat-design-tokens/editor/neovim/hexokinase-refs.json'),
    }

  end,
}

