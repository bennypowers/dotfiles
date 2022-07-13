local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local utils = require("luasnip_snippets.utils")

return {
  git = {
    -- choice node > commit types
    -- choice node > scope yes/no
    s({
      'chore',
      'docs',
      'feat',
      'fix',
      'style',
    }, {
      i(1, "type"), t("("), i(2, "scope"), t("): "), i(3, "description"),
    }),
  }
}
