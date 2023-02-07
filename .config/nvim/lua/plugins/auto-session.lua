return { 'rmagatti/auto-session',
  dependencies = {
    { 'rmagatti/session-lens', lazy = true }
  },
  opts = {
    log_level = 'error',
    auto_session_create_enabled = false,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_use_git_branch = true,
    bypass_session_save_file_types = {
      'neo-tree',
      'terminal',
      'tsplayground',
      'query',
    },
  },
}
