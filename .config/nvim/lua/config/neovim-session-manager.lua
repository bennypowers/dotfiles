return function ()
  local manager = require'session_manager'
  local config = require'session_manager.config'
  require'telescope'.load_extension'session_manager'
  manager.setup {
    autoload_mode = config.AutoloadMode.CurrentDir,
    autosave_ignore_filetypes = {
      'gitcommit',
      'neo-tree',
      'trouble',
      'Trouble',
    },
  }
end
