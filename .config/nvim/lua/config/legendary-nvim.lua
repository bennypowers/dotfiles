local can_legendary, legendary = pcall(require, 'legendary')
if can_legendary then
  legendary.setup {
    include_builtin = true,
    auto_register_which_key = true,
    select_prompt = 'Command Pallete'
  }

  local function toggle_inlayhints()
    require'lsp-inlayhints'.toggle()
  end

  legendary.bind_commands {
    { ':GHOpenPR<cr>', description = 'GitHub Open PR' },
    { ':GHClosePR<cr>', description = 'GitHub Close PR' },
    { ':GHAddLabel<cr>', description = 'GitHub Add Label' },
    { ':ToggleInlayHints', toggle_inlayhints, description = 'Toggle Inlay Hints' },
  }
end
