return { 'rmagatti/auto-session',
  version = 'v2.*',
  enabled = false,
  opts = {
    log_level = vim.log.levels.ERROR,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_create_enabled = false,
    -- auto_session_suppress_dirs = {},
    auto_session_use_git_branch = true,
    auto_session_enable_last_session = true,
    session_lens = {
      theme_conf = { border = false },
      previewer = true,
    },
    bypass_session_save_file_types = {
      'alpha',
      'neo-tree',
      'terminal',
      'tsplayground',
      'query',
    },
  },
}
