local nightfox = require'nightfox'

-- This function set the configuration of nightfox. If a value is not passed in the setup function
-- it will be taken from the default configuration above
nightfox.setup{
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

require'matchparen'.setup()

-- {
--   bg = "#192330",
--   bg_alt = "#131A24",
--   bg_float = "#131A24",
--   bg_highlight = "#283648",
--   bg_popup = "#131A24",
--   bg_search = "#2F5660",
--   bg_sidebar = "#131A24",
--   bg_statusline = "#131A24",
--   bg_visual = "#2B3B51",
--   black = "#393b44",
--   black_br = "#475072",
--   black_dm = "#32343b",
--   blue = "#719cd6",
--   blue_br = "#84cee4",
--   blue_dm = "#5483c1",
--   border = "#393b44",
--   border_highlight = "#719cd6",
--   comment = "#526175",
--   cyan = "#63cdcf",
--   cyan_br = "#59f0ff",
--   cyan_dm = "#4ab8ba",
--   diff = {
--     add = "#293840",
--     change = "#263549",
--     delete = "#332A39",
--     text = "#3C5372"
--   },
--   error = "#c94f6d",
--   fg = "#cdcecf",
--   fg_alt = "#AEAFB0",
--   fg_gutter = "#3b4261",
--   fg_sidebar = "#AEAFB0",
--   git = {
--     add = "#70a288",
--     change = "#a58155",
--     conflict = "#c07a6d",
--     delete = "#904a6a",
--     ignore = "#393b44"
--   },
--   gitSigns = {
--     add = "#266d6a",
--     change = "#536c9e",
--     delete = "#b2555b"
--   },
--   green = "#81b29a",
--   green_br = "#58cd8b",
--   green_dm = "#689c83",
--   harsh = "#dfdfe0",
--   hint = "#63cdcf",
--   info = "#719cd6",
--   magenta = "#9d79d6",
--   magenta_br = "#b8a1e3",
--   magenta_dm = "#835dc1",
--   meta = {
--     light = false,
--     name = "nightfox"
--   },
--   none = "NONE",
--   orange = "#f4a261",
--   orange_br = "#f6a878",
--   orange_dm = "#e28940",
--   pink = "#d67ad2",
--   pink_br = "#df97db",
--   pink_dm = "#c15dbc",
--   red = "#c94f6d",
--   red_br = "#d6616b",
--   red_dm = "#ad425c",
--   subtle = "#393b44",
--   variable = "#dfdfe0",
--   warning = "#dbc074",
--   white = "#dfdfe0",
--   white_br = "#f2f2f2",
--   white_dm = "#bdbdc0",
--   yellow = "#dbc074",
--   yellow_br = "#ffe37e",
--   yellow_dm = "#c7a957"
-- }
