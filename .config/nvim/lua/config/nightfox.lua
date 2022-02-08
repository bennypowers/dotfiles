return function()
  local nightfox = require'nightfox'

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
      LspCodeLens = {
        bg = "${bg}",
        style = "italic"
      },
    }
  }

  -- Load the configuration set above and apply the colorscheme
  nightfox.load'duskfox'

  require'matchparen'.setup {
    on_startup = true,
    hl_group = 'MatchParen',
  }
end
