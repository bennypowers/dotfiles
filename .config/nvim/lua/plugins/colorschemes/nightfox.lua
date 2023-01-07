return { 'EdenEast/nightfox.nvim', enabled = false, config = function()

local nightfox = require'nightfox'

-- This function set the configuration of nightfox. If a value is not passed in the setup function
-- it will be taken from the default configuration above
nightfox.setup {
  options = {
    dim_inactive = true,
    modules = {
      cmp = true,
      diagnostic = true,
      lsp_trouble = true,
      gitsigns = true,
      modes = true,
      illuminate = true,
      native_lsp = true,
      neogit = true,
      nvimtree = true,
      telescope = true,
      treesitter = true,
      whichkey = true,
    },
    styles = {
      comments = 'italic',
      keywords = 'bold',
      functions = 'italic,bold'
    },
  },
  palettes = {
    duskfox = {
      bg0  = '#1d1d2b',
      bg1  = '#000000',
      bg3  = '#121820', -- 55% darkened from stock
    },
  },
  specs = {
    all = {
      inactive = 'bg0',
    },
    duskfox = {
      inactive = '#090909',
    },
  },
  groups = {
    TSPunctDelimiter =           { fg = 'palette.red' },
    CursorLine =                 {             bg = 'bg3' },
    Comment =                    {                         style = 'italic' },
    MatchParen =                 { fg = 'palette.yellow' },
    IndentBlankLineContextChar = { fg = '#88ddff' },
    GitSignsChange =             { fg = '#f16d0a' },
    Folded =                     {             bg = 'bg1', },
    LspCodeLens =                {             bg = "bg1", style = 'italic' },
    NormalNC =                   { fg = "fg1", bg = 'inactive' },
    NeoTreeNormal =              {             bg = 'bg1' },
 }
}

vim.cmd[[colorscheme duskfox]]

end }
