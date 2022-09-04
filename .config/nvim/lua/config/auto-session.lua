local TREE_STATE = '__AS_NT_FS_Open'

local function has_tree()
  local manager = require 'neo-tree.sources.manager'
  local states = manager.get_state 'filesystem'
  vim.api.nvim_set_var(TREE_STATE, #states > 0)
end

local function close_neo_tree()
  local manager = require 'neo-tree.sources.manager'
  has_tree()
  manager.close_all()
end

local function open_neo_tree()
  local success, state = pcall(vim.api.nvim_get_var, TREE_STATE)
  if success and state then
    local Lib = require'auto-session-library'
    Lib.logger.debug 'found open filesystem neo-tree'
    require 'neo-tree.sources.manager'.show('filesystem')
  end
end

require 'auto-session'.setup {
  log_level = 'error',
  auto_session_create_enabled = false,
  auto_save_enabled = true,
  auto_restore_enabled = true,
  auto_session_use_git_branch = true,
  bypass_session_save_file_types = {
    "neo-tree",
    "tsplayground",
    "query",
  },
  pre_save_cmds = {
    close_neo_tree,
  },
  post_restore_cmds = {
    open_neo_tree,
  }
}
