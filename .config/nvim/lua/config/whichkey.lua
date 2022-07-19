vim.cmd [[nmap ; <C-w>]]

require 'config.legendary-nvim'

local wk = require 'which-key'
local U = require 'utils'

local normal_mappings = require 'mappings.n'
local visual_mappings = require 'mappings.v'
local insert_mappings = require 'mappings.i'

wk.setup {
  plugins = {
    spelling = {
      enabled = true,
    },
    presets = {
      -- modes.nvim is incompatible
      -- https://github.com/mvllow/modes.nvim/blob/b1cea686c049b03cb01300b6a6367b81302d2a90/readme.md#known-issues
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  operators = { gc = "Comments" },
}

wk.register({
  [';'] = {
    name     = 'Window management',
    w        = { U.pick_window, 'Pick Window' },
    s        = "Split window",
    v        = "Split window vertically",
    q        = "Quit a window",
    T        = "Break out into a new tab",
    x        = "Swap current with next",
    ["-"]    = "Decrease height",
    ["+"]    = "Increase height",
    ["<lt>"] = "Decrease width",
    [">"]    = "Increase width",
    ["|"]    = "Max out the width",
    ["="]    = "Equally high and wide",
    h        = "Go to the left window",
    l        = "Go to the right window",
    k        = "Go to the up window",
    j        = "Go to the down window",
  },
}, { preset = true })

-- Normal mode
wk.register(normal_mappings, { mode = 'n' })

-- Visual mode
wk.register(visual_mappings, { mode = 'v' })

-- Insert mode
wk.register(insert_mappings, { mode = 'i' })

---PATCH from https://github.com/folke/which-key.nvim/pull/305
local wk_view = require 'which-key.view'
wk_view.hide = function()
  vim.api.nvim_echo({ { "" } }, false, {})
  vim.cmd 'redraw'
  wk_view.hide_cursor()
  if wk_view.buf and vim.api.nvim_buf_is_valid(wk_view.buf) then
    vim.api.nvim_buf_delete(wk_view.buf, { force = true })
    wk_view.buf = nil
  end
  if wk_view.win and vim.api.nvim_win_is_valid(wk_view.win) then
    vim.api.nvim_win_close(wk_view.win, { force = true })
    wk_view.win = nil
  end
end
---ENDPATCH
