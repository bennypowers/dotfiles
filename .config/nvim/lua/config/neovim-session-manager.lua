local manager = require 'session_manager'
local config = require 'session_manager.config'
require 'telescope'.load_extension 'sessions_picker'
manager.setup {
  autoload_mode = config.AutoloadMode.CurrentDir,
  autosave_only_in_session = true,
  autosave_ignore_filetypes = {
    'Regexplainer',
    'gitcommit',
    'neo-tree',
    'trouble',
    'Trouble',
  },
}
