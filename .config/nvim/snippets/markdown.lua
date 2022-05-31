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

local fenced = [[
```{}
{}
```
]]

---@param lang string Fenced code block language tag
---@param placeholder string Placeholder text
local function fenced_code_block(lang, placeholder)
  return s({
    trig = lang,
    name = lang:upper() .. ' fenced code block',
  }, fmt(fenced, {
    t(lang),
    i(1, placeholder)
  }))
end

return {
  s({ trig = '```', name = 'fenced code block' }, fmt(fenced, { i(1, 'lang'), i(2, 'body') })),
  fenced_code_block('html', '<p>Insert your HTML</p>'),
  fenced_code_block('css', ':host { display: block; }'),
  fenced_code_block('bash', '#!/bin/bash'),
  fenced_code_block('sh', 'npm i lit'),
  fenced_code_block('js', 'console.log("hello world")');
  fenced_code_block('ts', 'console.log("hello world")'),
}
