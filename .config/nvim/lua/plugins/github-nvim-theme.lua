return { 'projekt0n/github-nvim-theme', config = function()

local is_gh_theme = vim.g.colors_name:match [[%^github]]
if is_gh_theme then
  local au = vim.api.nvim_create_autocmd
  local ag = vim.api.nvim_create_augroup
  require 'github-theme'.setup {
    theme_style = 'dark_default',
    transparent = true,
    dark_float = true,
    sidebars = {
      'neo-tree',
    },
    dev = true,
    ---@param c gt.ColorPalette
    overrides = function(c)
      local util = require 'github-theme.util'
      local telescope_preview_bg = util.darken(c.bright_black, 0.1)
      local telescope_prompt_bg = util.darken(c.blue, 0.1)
      local telescope_results_bg = c.bg2
      return {
        TelescopePreviewBorder = { bg = telescope_preview_bg, fg = telescope_preview_bg },
        TelescopePreviewNormal = { bg = telescope_preview_bg },
        TelescopePreviewTitle = { fg = c.fg },

        TelescopePromptBorder = { bg = telescope_prompt_bg, fg = telescope_prompt_bg },
        TelescopePromptNormal = { bg = telescope_prompt_bg, fg = c.fg },
        TelescopePromptPrefix = { bg = telescope_prompt_bg, fg = c.fg },
        TelescopePromptCounter = { fg = c.fg },
        TelescopePromptTitle = { bg = telescope_prompt_bg, fg = c.fg },

        TelescopeResultsBorder = { bg = telescope_results_bg, fg = telescope_results_bg },
        TelescopeResultsNormal = { bg = telescope_results_bg },
        TelescopeResultsTitle = { bg = telescope_results_bg, fg = c.fg },

        LineNr = { fg = util.darken(c.syntax.comment, 0.5), blend = 50 },
        CursorLineNr = { style = "bold" },
        CursorLine = { bg = c.bg_highlight, blend = 50 },
        CursorColumn = { bg = c.bg_highlight, blend = 50 },
        ColorColumn = { bg = c.bg_highlight, blend = 50 },

        Pmenu = { fg = c.fg, bg = util.darken(c.syntax.func, 0.1) },
      }
    end
  }

  au('BufWritePost', {
    pattern = 'github-nvim-theme.lua',
    group = ag('gh-theme-reload', {}),
    command = [[luafile %]],
  })
end

end }
