local M = {}

function M.setup()
  require('base16-colorscheme').setup {
    -- Background tones
    base00 = '#1d1012', -- Default Background
    base01 = '#2a1c1e', -- Lighter Background (status bars)
    base02 = '#352629', -- Selection Background
    base03 = '#ab888e', -- Comments, Invisibles
    -- Foreground tones
    base04 = '#e4bdc3', -- Dark Foreground (status bars)
    base05 = '#f7dce0', -- Default Foreground
    base06 = '#f7dce0', -- Light Foreground
    base07 = '#f7dce0', -- Lightest Foreground
    -- Accent colors
    base08 = '#ffb4ab', -- Variables, XML Tags, Errors
    base09 = '#ffb1c1', -- Integers, Constants
    base0A = '#e0b8f6', -- Classes, Search Background
    base0B = '#e4b5ff', -- Strings, Diff Inserted
    base0C = '#ffb1c1', -- Regex, Escape Chars
    base0D = '#e4b5ff', -- Functions, Methods
    base0E = '#e0b8f6', -- Keywords, Storage
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
