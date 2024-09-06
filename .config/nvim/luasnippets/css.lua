local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require 'luasnip.extras.fmt'.fmt

local read_flattened_tokens = require'design-tokens'.read_flattened_tokens

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
    return s(get_context(token, 'property'), fmt([[var(--{}{});]], {
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

local rhds_tokens = read_flattened_tokens'~/Developer/redhat-ux/red-hat-design-tokens/json/rhds.tokens.json';

return vim.iter(rhds_tokens)
  :map(make_snippets)
  :flatten()
  :totable()
