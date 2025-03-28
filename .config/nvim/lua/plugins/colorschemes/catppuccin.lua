return { 'catppuccin/nvim',
  enabled = true,
  name = 'catppuccin',
  priority = 1000,
  opts = {
    default_integrations = true,
    integrations = {
      lsp_trouble = true,
      notify = true,
      blink_cmp = true,
      which_key = true,
    },

    custom_highlights = function ()
      local colors = require 'catppuccin.palettes'.get_palette()
      local darken = require 'catppuccin.utils.colors'.darken
      local dark = {}

      for k, v in pairs(colors) do
        if k ~= 'none' then
          dark[k] = darken(v, 0.5)
        end
      end

      return {
        Folded = { fg = colors.subtext0, bg = 'NONE' },

        ModesCopy   = { bg = dark.orange, fg = colors.orange },
        ModesDelete = { bg = dark.red, fg = colors.red },
        ModesInsert = { bg = dark.blue, fg = colors.blue },
        ModesVisual = { bg = dark.purple, fg = colors.purple },

        TelescopePromptPrefix = { bg = colors.crust },
        TelescopePromptNormal = { bg = colors.crust },
        TelescopeResultsNormal = { bg = colors.mantle },
        TelescopePreviewNormal = { bg = colors.crust },
        TelescopePromptBorder = { bg = colors.crust, fg = colors.crust },
        TelescopeResultsBorder = { bg = colors.mantle, fg = colors.crust },
        TelescopePreviewBorder = { bg = colors.crust, fg = colors.crust },
        TelescopePromptTitle = { fg = colors.crust },
        TelescopeResultsTitle = { fg = colors.text },
        TelescopePreviewTitle = { fg = colors.crust },
      }
    end
  },
}
