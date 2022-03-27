local function new_version()
  require'config.modes'()
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
        comments = "italic",
        keywords = "bold",
        functions = "italic,bold"
      },
    },
    pallets = {
      duskfox = {
        bg1 = "#000000",
        bg0 = "#010101",
        bg3 = "#121820", -- 55% darkened from stock
        sel0 = "#131b24", -- 55% darkened from stock
      },
    },
    groups = {
      TSPunctDelimiter = { fg = "pallet.red" },
      CursorLine = { bg = 'bg3' },
      Comment = { style = "italic" },
      MatchParen = { fg = "pallet.yellow" },
      IndentBlankLineContextChar = { fg = '#88ddff' },
      GitSignsChange = { fg='#f16d0a' },
      Folded = {  bg = 'bg1', },
      LspCodeLens = {  bg = "bg1",  style = "italic" },
    }
  }
  -- vim.cmd[[
  --   colorscheme duskfox
  --   augroup FixIlluminateNightfox
  --     au!
  --     au InsertLeave * colorscheme duskfox
  --   augroup END
  -- ]]
end

local function old_version()
  local can, nightfox = pcall(require, 'nightfox');
  if not can then return end

  -- This function set the configuration of nightfox. If a value is not passed in the setup function
  -- it will be taken from the default configuration above
  nightfox.setup {
    fox = 'duskfox',
    alt_nc = true,
    styles = {
      comments = "italic", -- change style of comments to be italic
      keywords = "bold", -- change style of keywords to be bold
      functions = "italic,bold" -- styles can be a comma separated list
    },
    inverse = {
      -- match_paren = false, -- inverse the highlighting of match_parens
      -- match_paren = true, -- inverse the highlighting of match_parens
    },
    colors = {
      bg = "#000000",
      bg_alt = "#010101",
      bg_highlight = "#121820", -- 55% darkened from stock
      -- bg_visual = "#151d28", -- 50% darkened from stock
      -- bg_visual = "#111820", -- 60% darkened from stock
      bg_visual = "#131b24", -- 55% darkened from stock
    },
    hlgroups = {
      TSPunctDelimiter = { fg = "${red}" }, -- Override a highlight group with the color red

      Comment = { style = "italic" },
      MatchParen = { fg = "yellow" },
      IndentBlankLineContextChar = { fg = '#88ddff' },
      GitSignsChange = { fg='#f16d0a' },

      Folded = {
        bg = '${bg}',
      },
      LspCodeLens = {
        bg = "${bg}",
        style = "italic"
      },
    }
  }

  -- Load the configuration set above and apply the colorscheme
  nightfox.load'duskfox'
end

return old_version
-- return new_version
