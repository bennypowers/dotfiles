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

local function read_file(filename)
  return io.open(filename, 'r'):read('*a')
end

local function read_tokens(json_file_path)
  local expanded = vim.fn.expand(json_file_path)
  local did_read, contents = pcall(read_file,expanded)
  if not did_read then vim.notify('could not read '..json_file_path .. ' ' .. contents)
  else
    local did_parse, json = pcall(vim.json.decode,contents)
    if not did_parse then vim.notify('could not parse '..json_file_path)
    else
      return json
    end
  end
end

local function flatten_tokens(deep_tokens)
  local flattened_tokens = {}

  local function get_child_tokens(_, child)
    if (type(child) == 'table') then
      if child['$value'] then
        table.insert(flattened_tokens,child)
      else
        vim.iter(child)
          :each(get_child_tokens)
      end
    end
  end

  vim.iter(deep_tokens)
    :each(get_child_tokens)

  return flattened_tokens
end

---@param line_to_cursor string
local function get_property_name_from_line(line_to_cursor)
  local name = line_to_cursor:match[[%s*([%w-]+)]]
  return name
end

local function is_matching_token_type_for_property(token, property)
  if vim.startswith(property, '--') then
    return true
  end
  local ttype = token['$type']
  if not ttype then
    return true
  end
  if property == 'font-family' then
    return ttype == 'fontFamily'
  elseif property == 'font-size' then
    return ttype == 'dimension'
    -- todo: custom predicates
    -- and token.attributes.category == 'typography' and token.type == 'font-size'
  elseif vim.endswith(property, 'color') then
    return ttype == 'color'
  end
  return true
end

local function get_context(token, snippet_type)
  local td = token['$description']
  -- json.decode can produce `vim.NIL` types
  if td == vim.NIL then td = nil end
  return {
    trig = token.name,
    name = '--' .. token.name,
    desc = td or nil,
    show_condition = function(line_to_cursor)
      local after_colon = line_to_cursor:match':';
      if snippet_type == 'property' then
        return after_colon and is_matching_token_type_for_property(
          token,
          get_property_name_from_line(line_to_cursor)
        )
      else
        return not after_colon
      end
    end,
  }
end

local function get_property_snippet(token)
  return
  s(get_context(token, 'property'), fmt([[var(--{}{});]], {
      t(token.name),
      c(1, {
        t'',
        t(', '..token['$value'])
      }),
  }))
end

local function get_value_snippet(token)
  return s(get_context(token, 'value'), fmt([[--{}: {}]], { t(token.name), i(1) }))
end

local function make_snippets(token)
  return {
    get_property_snippet(token),
    get_value_snippet(token),
  }
end

local tokens = read_tokens'~/Developer/redhat-ux/red-hat-design-tokens/json/rhds.tokens.json'

return vim.iter(flatten_tokens(tokens))
  :map(make_snippets)
  :flatten()
  :totable()
