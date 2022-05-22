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
  },
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
