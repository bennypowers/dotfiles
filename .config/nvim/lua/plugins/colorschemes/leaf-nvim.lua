return { 'daschw/leaf.nvim',
  lazy = true,
  enabled = false,
  config = function()
    local colors = require'leaf.colors'.setup()
    require'leaf'.setup {
      theme = 'dark',

      transparent = true,

      -- contrast = 'low',
      -- contrast = 'medium',
      contrast = 'high',

      overrides = {
        TelescopeBorder = { link = 'Normal' },
        Folded = { bg = colors.darker },

        Pmenu = { bg = colors.darker },
        PmenuSel = { fg = "NONE", bg = colors.darker },

        CmpItemAbbrDeprecated = { fg = colors.light_dim, bg = "NONE", style = "strikethrough" },
        CmpItemAbbrMatch = { fg = colors.green_lighter, bg = "NONE", style = "bold" },
        CmpItemAbbrMatchFuzzy = { fg = colors.green_lighter, bg = "NONE", style = "bold" },
        CmpItemMenu = { fg = colors.red_dark, bg = "NONE", style = "italic" },

        CmpItemKindField = { fg = colors.red_lightest, bg = colors.red_darker },
        CmpItemKindProperty = { fg = colors.red_lightest, bg = colors.red_darker },
        CmpItemKindEvent = { fg = colors.red_lightest, bg = colors.red_darker },

        CmpItemKindText = { fg = colors.green_lightest, bg = colors.green_darkest },
        CmpItemKindEnum = { fg = colors.green_lightest, bg = colors.green_darkest },
        CmpItemKindKeyword = { fg = colors.green_lightest, bg = colors.green_darkest },

        CmpItemKindConstant = { fg = colors.yellow_lightest, bg = colors.yellow_darkest },
        CmpItemKindConstructor = { fg = colors.yellow_lightest, bg = colors.yellow_darkest },
        CmpItemKindReference = { fg = colors.yellow_lightest, bg = colors.yellow_darkest },

        CmpItemKindFunction = { fg = colors.purple_lightest, bg = colors.purple_darkest },
        CmpItemKindStruct = { fg = colors.purple_lightest, bg = colors.purple_darkest },
        CmpItemKindClass = { fg = colors.purple_lightest, bg = colors.purple_darkest },
        CmpItemKindModule = { fg = colors.purple_lightest, bg = colors.purple_darkest },
        CmpItemKindOperator = { fg = colors.purple_lightest, bg = colors.purple_darkest },

        CmpItemKindVariable = { fg = colors.dark_dimmest, bg = colors.darker },
        CmpItemKindFile = { fg = colors.dark_dimmest, bg = colors.darker },

        CmpItemKindUnit = { fg = colors.blue_lightest, bg = colors.blue_darkest },
        CmpItemKindSnippet = { fg = colors.blue_lightest, bg = colors.blue_darkest },
        CmpItemKindFolder = { fg = colors.blue_lightest, bg = colors.blue_darkest },

        CmpItemKindMethod = { fg = colors.purple_lightest, bg = colors.red_darkest },
        CmpItemKindValue = { fg = colors.purple_lightest, bg = colors.red_darkest },
        CmpItemKindEnumMember = { fg = colors.purple_lightest, bg = colors.red_darkest },

        CmpItemKindInterface = { fg = colors.teal_lightest, bg = colors.teal_darkest },
        CmpItemKindColor = { fg = colors.teal_lightest, bg = colors.teal_darkest },
        CmpItemKindTypeParameter = { fg = colors.teal_lightest, bg = colors.teal_darkest },

      },

    }

    au('BufWrite', {
      group = ag('leaf_theme', {}),
      pattern = 'leaf-nvim.lua',
      callback = function (e)
        vim.cmd.luafile(e.match)
      end
    })
  end
}
