local colors = require 'catppuccin.palettes'.get_palette()
local darken = require 'catppuccin.utils.colors'.darken
local dark = {}
for k, v in pairs(colors) do
  if k ~= 'none' then
    dark[k] = darken(v, 0.5)
  end
end

vim.g.catppuccin_flavour = 'mocha'
require 'catppuccin'.setup {
  transparent_background = true,
  compile = {
    enabled = true,
  },
  integrations = {
    coc_nvim = false,
    lsp_trouble = false,
    cmp = true,
    lsp_saga = false,
    gitgutter = false,
    gitsigns = true,
    telescope = true,
    treesitter = true,
    which_key = true,
    dashboard = true,
    neogit = false,
    vim_sneak = false,
    fern = false,
    barbar = false,
    bufferline = true,
    markdown = true,
    lightspeed = false,
    ts_rainbow = false,
    hop = false,
    notify = true,
    telekasten = true,
    symbols_outline = true,
    mini = false,

    neotree = {
      enabled = true,
      show_root = true,
      transparent_panel = true,
    },

    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },

    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
    },
    nvimtree = {
      enabled = true,
      show_root = true,
      transparent_panel = false,
    },
    dap = {
      enabled = false,
      enable_ui = false,
    },
  },
  custom_highlights = {
    Folded = { fg = colors.subtext0, bg = 'NONE' },
    PmenuSel = { bg = "#282C34", fg = "NONE" },
    Pmenu = { fg = "#C5CDD9", bg = "#22252A" },

    CmpItemAbbrDeprecated = { fg = colors.subtext0, bg = "NONE", style = { "strikethrough" } },
    CmpItemAbbrMatch = { fg = colors.sky, bg = "NONE", style = { "bold" } },
    CmpItemAbbrMatchFuzzy = { fg = colors.sky, bg = "NONE", style = { "bold" } },
    CmpItemMenu = { fg = colors.mauve, bg = "NONE", style = { "italic" } },

    CmpItemKindField = { fg = colors.maroon, bg = dark.maroon },
    CmpItemKindProperty = { fg = colors.maroon, bg = dark.maroon },
    CmpItemKindEvent = { fg = colors.maroon, bg = dark.maroon },

    CmpItemKindText = { fg = colors.green, bg = dark.green },
    CmpItemKindEnum = { fg = colors.green, bg = dark.green },
    CmpItemKindKeyword = { fg = colors.green, bg = dark.green },

    CmpItemKindConstant = { fg = colors.yellow, bg = dark.yellow },
    CmpItemKindConstructor = { fg = colors.yellow, bg = dark.yellow },
    CmpItemKindReference = { fg = colors.yellow, bg = dark.yellow },

    CmpItemKindFunction = { fg = colors.mauve, bg = dark.mauve },
    CmpItemKindStruct = { fg = colors.mauve, bg = dark.mauve },
    CmpItemKindClass = { fg = colors.mauve, bg = dark.mauve },
    CmpItemKindModule = { fg = colors.mauve, bg = dark.mauve },
    CmpItemKindOperator = { fg = colors.mauve, bg = dark.mauve },

    CmpItemKindVariable = { fg = colors.text, bg = colors.overlay0 },
    CmpItemKindFile = { fg = colors.text, bg = colors.overlay0 },

    CmpItemKindUnit = { fg = colors.peach, bg = dark.peach },
    CmpItemKindSnippet = { fg = colors.peach, bg = dark.peach },
    CmpItemKindFolder = { fg = colors.peach, bg = dark.peach },

    CmpItemKindMethod = { fg = colors.lavender, bg = colors.mauve },
    CmpItemKindValue = { fg = colors.lavender, bg = colors.mauve },
    CmpItemKindEnumMember = { fg = colors.lavender, bg = colors.mauve },

    CmpItemKindInterface = { fg = colors.teal, bg = dark.teal },
    CmpItemKindColor = { fg = colors.teal, bg = dark.teal },
    CmpItemKindTypeParameter = { fg = colors.teal, bg = dark.teal },

    --transparent_background tweak
    Comment = { fg = colors.overlay1 },
    LineNr = { fg = colors.overlay1 },
    CursorLine = { bg = colors.none },
    CursorLineNr = { fg = colors.lavender },
    DiagnosticVirtualTextError = { bg = colors.none },
    DiagnosticVirtualTextWarn = { bg = colors.none },
    DiagnosticVirtualTextInfo = { bg = colors.none },
    DiagnosticVirtualTextHint = { bg = colors.none },

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
}

vim.cmd 'colorscheme catppuccin'
