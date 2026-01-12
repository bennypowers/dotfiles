local M = {}

function M.setup()
  require('base16-colorscheme').setup {
    -- Background tones
    base00 = '#091615', -- Default Background
    base01 = '#152221', -- Lighter Background (status bars)
    base02 = '#1f2c2c', -- Selection Background
    base03 = '#7b9694', -- Comments, Invisibles
    -- Foreground tones
    base04 = '#b0ccca', -- Dark Foreground (status bars)
    base05 = '#d7e5e4', -- Default Foreground
    base06 = '#d7e5e4', -- Light Foreground
    base07 = '#d7e5e4', -- Lightest Foreground
    -- Accent colors
    base08 = '#ffb4ab', -- Variables, XML Tags, Errors
    base09 = '#80d5d1', -- Integers, Constants
    base0A = '#a4d397', -- Classes, Search Background
    base0B = '#94d786', -- Strings, Diff Inserted
    base0C = '#80d5d1', -- Regex, Escape Chars
    base0D = '#94d786', -- Functions, Methods
    base0E = '#a4d397', -- Keywords, Storage
    base0F = '#93000a', -- Deprecated, Embedded Tags
  }
end

-- Register a signal handler for SIGUSR1 (matugen updates)
local signal = vim.uv.new_signal()
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
