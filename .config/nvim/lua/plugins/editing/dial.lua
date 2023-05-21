local function get_map(c, m, g) return function()
  if vim.bo.filetype == 'markdown' then
    pcall(require'commands'.toggle_markdown_image)
  end
  require'dial.map'.manipulate(c, m, g)
end end

-- c-a to toggle bool, increment version, etc
return { 'monaqa/dial.nvim',
  lazy = true,
  keys = {
    { '<c-a>',  get_map('increment','normal'),  mode = {'n'}, desc = 'Increment (dial)' },
    { '<c-x>',  get_map('decrement','normal'),  mode = {'n'}, desc = 'Decrement (dial)' },
    { 'g<c-a>', get_map('increment','gnormal'), mode = {'n'}, desc = 'Increment (g) (dial)' },
    { 'g<c-x>', get_map('decrement','gnormal'), mode = {'n'}, desc = 'Decrement (g) (dial)' },
    { '<c-a>',  get_map('increment','visual'),  mode = {'v'}, desc = 'Increment (dial)' },
    { '<c-x>',  get_map('decrement','visual'),  mode = {'v'}, desc = 'Decrement (dial)' },
    { 'g<c-a>', get_map('increment','gvisual'), mode = {'v'}, desc = 'Increment (g) (dial)' },
    { 'g<c-x>', get_map('decrement','gvisual'), mode = {'v'}, desc = 'Decrement (g) (dial)' },
  },
  config = function()
    local a = require'dial.augend'
    require'dial.config'.augends:register_group {
      default = {
        a.integer.alias.decimal,
        a.constant.alias.bool,
        a.semver.alias.semver,
        a.misc.alias.markdown_header,
        a.hexcolor.new { case = "lower" },
      }
    }
  end
}
