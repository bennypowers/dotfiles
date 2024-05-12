return { 'johmsalas/text-case.nvim',
  dependencies = { 'telescope' },
  enabled = true,
  config = function()
    require'textcase'.setup{}
    require'telescope'.load_extension'textcase'
  end,
  keys = {
    'ga',
    { 'ga', '<cmd>TextCaseOpenTelescope<CR>', mode = { 'n', 'x' }, desc = 'Caser menu' },
  },
  cmd = {
    -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
    'Subs',
    'TextCaseOpenTelescope',
    'TextCaseOpenTelescopeQuickChange',
    'TextCaseOpenTelescopeLSPChange',
    'TextCaseStartReplacingCommand',
  },
}
