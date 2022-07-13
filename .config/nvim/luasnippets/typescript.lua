local ls = require 'luasnip'
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require 'luasnip.util.events'
local ai = require 'luasnip.nodes.absolute_indexer'
local fmt = require 'luasnip.extras.fmt'.fmt
local m = require 'luasnip.extras'.m
local lambda = require 'luasnip.extras'.l

local function toTitle(str)
  return string.sub(str, 1, 1):upper() .. string.sub(str, 2):lower()
end

local function dash_to_pascal_case(str)
  local parts = vim.tbl_map(toTitle, vim.split(str, '-'))
  return table.concat(parts, "")
end

local function first_arg_dash_to_pascal(args)
  local tag_name = args[1][1]
  return dash_to_pascal_case(tag_name)
end

local function treesitter_customelement_dynamicnode(args)
  local parser = vim.treesitter.get_parser(0, 'typescript')
  local query = vim.treesitter.parse_query('typescript', [[
    (decorator
      (call_expression
        ((identifier) @decorator (arguments
          ((string) @tag_name))))
      (#eq? @decorator "customElement"))
    (class_declaration (type_identifier) @class_name)
  ]])
  local tree = parser:parse()[1]
  local results = {}


  for id, node in query:iter_captures(tree:root(), 0) do
    local name = query.captures[id]
    if name ~= 'decorator' then
      local text = vim.treesitter.query.get_node_text(node, 0)
      if text then
        results[name] = text
      end
    end
  end

  if results.tag_name and results.class_name then
    return sn(nil, { t(results.tag_name), t ': ', t(results.class_name) })
  else
    return sn(nil, { t "'", i(1, 'tag name'), t "': ", f(first_arg_dash_to_pascal, 1), })
  end
end

return {
  s('import', fmt([[import {} from '{}';]], {
    c(2, {
      sn('named import', { t('{ '), i(1, 'named import'), t(' }') }),
      sn('default import', i(1, 'default import')),
    }),
    i(1, 'specifier'),
  })),

  s('tagnamemap', {
    t {
      'declare global {',
      '  interface HTMLElementTagNameMap {',
      "    " }, d(1, treesitter_customelement_dynamicnode), t { ';',
      '  }',
      '}' },
  }),

}
