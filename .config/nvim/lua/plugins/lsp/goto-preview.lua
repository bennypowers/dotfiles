local function goto_definition()
  require 'goto-preview'.goto_preview_definition {}
end

local function goto_implementation()
  require 'goto-preview'.goto_preview_implementation {}
end

local function goto_references()
  require 'goto-preview'.goto_preview_references()
end

local function goto_type_definition()
  require 'goto-preview'.goto_preview_type_definition()
end

local function close_all_win()
  require 'goto-preview'.close_all_win()
end

-- gd, but in a floating window
return { 'rmagatti/goto-preview',
  lazy = true,
  requires = {'telescope'},
  keys = {
    { 'gpd', goto_definition,      desc = 'Preview Definition' },
    { 'gpi', goto_implementation,  desc = 'Preview implementation' },
    { 'gpr', goto_references,      desc = 'Preview References' },
    { 'gpt', goto_type_definition, desc = 'Preview Type Definitions' },
    { 'gP',  close_all_win,        desc = 'Preview References' },
  },
  config = function()
    require 'goto-preview'.setup {
      width = 120; -- Width of the floating window
      height = 15; -- Height of the floating window
      border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }; -- Border characters of the floating window
      default_mappings = false; -- Bind default mappings
      debug = false; -- Print debug information
      opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
      resizing_mappings = false; -- Binds arrow keys to resizing the floating window.
      post_open_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.
      references = { -- Configure the telescope UI for slowing the references cycling window.
        telescope = require 'telescope.themes'.get_dropdown({ hide_preview = false })
      };
      -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
      focus_on_open = false; -- Focus the floating window when opening it.
      dismiss_on_move = true; -- Dismiss the floating window when moving the cursor.
      force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
      bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
    }
  end,
}
