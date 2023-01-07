return { 'rmagatti/auto-session',
dependencies = { { 'rmagatti/session-lens', lazy = true } },
config = function ()

local TREE_STATE = '__AS_NT_FS_Open'
vim.g[TREE_STATE] = vim.g[TREE_STATE] == '1' or '0'

local function has_tree()
  local manager = require 'neo-tree.sources.manager'
  local states = manager.get_state 'filesystem'
  vim.g[TREE_STATE] = #states > 0 and '1' or '0'
end

has_tree()

local function close_neo_tree()
  local manager = require 'neo-tree.sources.manager'
  has_tree()
  manager.close_all()
end

local function open_neo_tree()
      vim.notify(vim.g[TREE_STATE])
  if vim.g[TREE_STATE] == '1' then
    vim.cmd [[ :Neotree show filesystem ]]
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
  post_save_cmds = {
    open_neo_tree,
  },
  post_restore_cmds = {
    open_neo_tree,
  }
}

end }
