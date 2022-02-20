 return function()
  local tree = require'neo-tree'
  local highlights = require'neo-tree.ui.highlights'

  tree.setup{
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,

    filesystem = {

      follow_current_file = true,
      use_libuv_file_watcher = true,

      filters = {
        show_hidden = true,
        respect_gitignore = true,
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
          ["I"] = "toggle_gitignore",
          ["R"] = "refresh",
          ["/"] = "filter_as_you_type",
          --["/"] = "none" -- Assigning a key to "none" will remove the default mapping
          ["f"] = "filter_on_submit",
          ["<c-x>"] = "clear_filter",
          ["a"] = "add",
          ["d"] = "delete",
          ["r"] = "rename",
          ["c"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["bd"] = "buffer_delete",
        },
      },

      renderers = {
        directory = {
          {
            "icon",
            folder_closed = "",
            folder_open = "",
            padding = " ",
          },
          { "current_filter" },
          { "name" },
          {
            "symlink_target",
            highlight = "NeoTreeSymbolicLinkTarget",
          },
          {
            "clipboard",
            highlight = "NeoTreeDimText",
          },
          { "diagnostics", errors_only = true },
        },
      },

      components = {
        icon = function (config, node)
          local icon = config.default or ' '
          local padding = config.padding or ' '
          local highlight = config.highlight or highlights.FILE_ICON
          local web_devicons = require'nvim-web-devicons'

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
            local _icon, _highlight = web_devicons.get_icon(node.name, node.ext)
            icon = _icon or icon
            highlight = _highlight or highlight
          end
          return {
            text = icon .. padding,
            highlight = highlight,
          }
        end
      }
    },

    buffers = {
      show_unloaded = false,
      window = {
        position = "left",
        mappings = {
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["R"] = "refresh",
          ["a"] = "add",
          ["d"] = "delete",
          ["r"] = "rename",
          ["c"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
        },
      },
    },

    git_status = {
      window = {
        position = "float",
        mappings = {
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["C"] = "close_node",
          ["R"] = "refresh",
          ["d"] = "delete",
          ["r"] = "rename",
          ["c"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["A"]  = "git_add_all",
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push",
        },
      },
    },

    event_handlers = {
      {
        event = "vim_buffer_enter",
        handler = function()
          if vim.bo.filetype == "neo-tree" then
            vim.cmd [[
              setlocal nocursorcolumn
              setlocal virtualedit=all
              hi link NeoTreeDirectoryName Directory
              hi link NeoTreeDirectoryIcon NeoTreeDirectoryName
            ]]
          end
        end
      },
    },

  }
end
