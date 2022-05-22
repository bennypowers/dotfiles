local can_legendary, legendary = pcall(require, 'legendary')
if can_legendary then
  legendary.setup {
    include_builtin = true,
    auto_register_which_key = true,
    select_prompt = 'Command Pallete'
  }
  legendary.bind_commands {
    { ':GHOpenPR<cr>', description = 'GitHub Open PR' },
    { ':GHClosePR<cr>', description = 'GitHub Close PR' },
    { ':GHAddLabel<cr>', description = 'GitHub Add Label' },
  }
end
