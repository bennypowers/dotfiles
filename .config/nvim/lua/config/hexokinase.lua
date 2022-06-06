vim.g.Hexokinase_optInPatterns = {
  'full_hex',
  'triple_hex',
  'rgb',
  'rgba',
  'hsl',
  'hsla',
  'colour_names',
}

vim.g.Hexokinase_ftOptOutPatterns = {
  json = { 'colour_names' },
  yaml = { 'colour_names' },
}

vim.g.Hexokinase_palettes = {
  -- replace with relevant path on your drive
  vim.fn.expand('~/Developer/redhat-ux/red-hat-design-tokens/build/editor/hexokinase.json')
}
