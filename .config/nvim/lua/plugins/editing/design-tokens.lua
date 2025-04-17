return { 'bennypowers/design-tokens.nvim',
  filetypes = {'css'},
  keys = {
    { '<leader>tt', function() require'designtokens'.cycle_fallbacks() end, desc = 'Toggle design token fallbacks' },
  },
  opts = {
    tokens = {
      -- vim.fn.expand'~/Developer/design-tokens/pf.json',
      -- vim.fn.expand'~/Developer/redhat-ux/red-hat-design-tokens/json/rhds.tokens.json',
    }
  }
}
