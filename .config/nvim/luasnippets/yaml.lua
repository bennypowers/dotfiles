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

local function is_github_issue_template()
  local file_name = vim.fn.expand('%')
  print(file_name)
  return file_name:find [[.github/ISSUE_TEMPLATE]]
end

local gh_form_markdown = s('form-markdown', fmt([[
- type: markdown
  attributes:
    value: |
      {}
]], {
  i(1, 'insert markdown body'),
}), {
  show_condition = is_github_issue_template
})

local gh_form_input = s('form-input', fmt([[
- type: input
  id: {}
  attributes:
    label: {}
    description: >-
      {}
    placeholder: >-
      {}
    value: {}
  validations:
    required: {}
  ]], {
  i(1),
  i(2),
  i(3),
  i(4),
  i(5),
  c(6, {
    t 'true',
    t 'false',
  }),
}), {
  show_condition = is_github_issue_template
})

local gh_form_textarea = s('form-textarea', fmt([[
- type: textarea
  id: {}
  attributes:
    label: {}
    description: >-
      {}
    placeholder: >-
      {}
    value: {}
    render: {}
  validations:
    required: {}
  ]], {
  i(1),
  i(2),
  i(3),
  i(4),
  i(5),
  c(6, {
    t 'HTML',
    t 'CSS',
    t 'SCSS',
    t 'JS',
    t 'TS',
    t 'JSON',
  }),
  c(7, {
    t 'true',
    t 'false',
  }),
}), {
  show_condition = is_github_issue_template
})

local gh_form_dropdown = s('form-dropdown', fmt([[
- type: dropdown
  id: {}
  attributes:
    label: {}
    description: >-
      {}
    multiple: {}
    options:
      - {}
  validations:
    required: {}
  ]], {
  i(1),
  i(2),
  i(3),
  c(4, {
    t 'true',
    t 'false',
  }),
  i(5),
  c(6, {
    t 'true',
    t 'false',
  }),
}), {
  show_condition = is_github_issue_template
})

local gh_form_checkboxes = s('form-checkboxes', fmt([[
- type: checkboxes
  id: {}
  attributes:
    label: {}
    description: >-
      {}
    options:
      - label: {}
        required: {}
  ]], {
  i(1),
  i(2),
  i(3),
  i(4),
  c(5, {
    t 'true',
    t 'false',
  }),
}), {
  show_condition = is_github_issue_template
})

return {
  gh_form_markdown,
  gh_form_input,
  gh_form_textarea,
  gh_form_dropdown,
  gh_form_checkboxes,
}
