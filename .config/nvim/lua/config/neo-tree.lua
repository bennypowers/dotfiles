local tree = require 'neo-tree'
local highlights = require 'neo-tree.ui.highlights'
local renderer = require 'neo-tree.ui.renderer'

-- ascend to the parent or close it
local function float(state)
  local node = state.tree:get_node()
  if (node.type == 'directory' or node:has_children()) and node:is_expanded() then
    state.commands.toggle_node(state)
  else
    renderer.focus_node(state, node:get_parent_id())
  end
end

-- toggle a node open or descend to it's first child
local function dive(state)
  local node = state.tree:get_node()
  if node.type == 'directory' or node:has_children() then
    if not node:is_expanded() then
      if node.type == 'directory' then
        require 'neo-tree.sources.filesystem'.toggle_directory(state, node)
      else
        state.commands.toggle_node(state)
      end
    else
      renderer.focus_node(state, node:get_child_ids()[1])
    end
  end
end

tree.setup {
  close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
  popup_border_style = "rounded",
  enable_git_status = true,
  enable_diagnostics = true,
  use_libuv_filewatcher = true,

  event_handlers = {
    {
      event = 'neo_tree_buffer_enter',
      handler = function()
        require 'cmp'.setup.buffer { enabled = false }
        vim.opt_local.signcolumn = 'no'
        vim.opt_local.cursorline = true
        vim.opt_local.cursorcolumn = false
        vim.opt_local.guicursor:append('a:Cursor/lCursor')
        vim.cmd [[
          hi Cursor blend=100
        ]]
      end
    },
    {
      event = "neo_tree_buffer_leave",
      handler = function()
        vim.cmd [[
          hi Cursor blend=0
        ]]
      end
    },
  },

  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 1, -- extra padding on left hand side
      -- indent guides
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
      -- expander config, needed for nesting files
      with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },

    icon = {
      -- folder_closed = "",
      -- folder_open = "",
      folder_closed = "",
      folder_open = "",
      folder_empty = "ﰊ",
      default = "*",
    },

    name = {
      trailing_slash = false,
      use_git_status_colors = true,
    },

    git_status = {
      symbols = {
        -- Change type
        added     = "✚",
        deleted   = "✖",
        modified  = "",
        renamed   = "",
        -- Status type
        untracked = "",
        ignored   = "",
        unstaged  = "",
        staged    = "",
        conflict  = "",
      }
    },
  },

  window = {
    position = "left",
    width = 40,
    mappings = {
      ["<2-LeftMouse>"] = "open",
      ["<cr>"] = "open",
      ["S"] = "open_split",
      ["s"] = "open_vsplit",
      ["C"] = "close_node",
      ["<bs>"] = "navigate_up",
      ["."] = "set_root",
      ["H"] = "toggle_hidden",
      ["R"] = "refresh",
      ["/"] = "fuzzy_finder",
      ["f"] = "filter_on_submit",
      ["<c-x>"] = "clear_filter",
      ["a"] = "add",
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["c"] = "copy", -- takes text input for destination
      ["m"] = "move", -- takes text input for destination
      ["q"] = "close_window",
      ["h"] = float,
      ["l"] = dive,
      ["<Left>"] = float,
      ["<Right>"] = dive,
    }
  },

  nesting_rules = {
    ts = { 'js', 'js.map', 'd.ts' },
    scss = { 'css', 'min.css', 'css.map', 'min.css.map' },
  },

  filesystem = {
    follow_current_file = true, -- This will find and focus the file in the active buffer every time the current file is changed while the tree is open.
    hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree in whatever position is specified in window.position
    filtered_items = {
      visible = true, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = true,
      hide_gitignored = true,
      hide_by_name = {
        ".DS_Store",
        "thumbs.db"
        --"node_modules"
      },
      never_show = { -- remains hidden even if visible is toggled to true
        --".DS_Store",
        --"thumbs.db"
      },
    },

    components = {

      icon = function(config, node)
        local icon = config.default or ' '
        local padding = config.padding or ' '
        local highlight = config.highlight or highlights.FILE_ICON
        local web_devicons = require 'nvim-web-devicons'
        if node.type == 'directory' then
          highlight = highlights.DIRECTORY_ICON
          if node.name == 'node_modules' or node.name == '.git' or node.name == '.github' then
            local _icon, _highlight = web_devicons.get_icon(node.name)
            icon = _icon or icon
            highlight = _highlight or highlight
          elseif node:is_expanded() then
            icon = config.folder_open or '-'
          else
            icon = config.folder_closed or '+'
          end
        elseif node.type == 'file' then
          ---@type string
          local name = node.name
          local ext = node.ext
          print(name, ext)
          if ext == 'json' and name:match[[^tsconfig]] then name = 'tsconfig.json' end
          local _icon, _highlight = web_devicons.get_icon(name, ext)
          icon = _icon or icon
          highlight = _highlight or highlight
        end
        return {
          text = icon .. padding,
          highlight = highlight,
        }
      end,

    },
  },

  buffers = {
    show_unloaded = true,
    window = {
      mappings = {
        ["bd"] = "buffer_delete",
      }
    },
  },

  git_status = {
    window = {
      position = "float",
      mappings = {
        ["A"]  = "git_add_all",
        ["gu"] = "git_unstage_file",
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
      }
    }
  }
}
