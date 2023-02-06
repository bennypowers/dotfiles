local function cycle_color()
  require 'color-converter'.cycle()
end

local function format_hsl()
  require 'color-converter'.to_hsl()
  vim.cmd [[:s/%//g<cr>]]
end

-- convert colour values
return { 'NTBBloodbath/color-converter.nvim',
  lazy = true,
  keys = {
    { '<leader>roc', cycle_color, desc = 'Cycle colour format' },
    { '<leader>roh', format_hsl,  desc = 'Format color as hsl()' },
    { 'roc', cycle_color, mode = 'v', desc = 'Cycle colour format' },
    { 'roh', format_hsl,  mode = 'v', desc = 'Format color as hsl()' },
  },
}

