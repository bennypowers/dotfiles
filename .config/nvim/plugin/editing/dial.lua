local u = require'utils'

local function get_map(c, m, g) return function()
  if vim.bo.filetype == 'markdown' then
    pcall(require'commands'.toggle_markdown_image)
  end
  require'dial.map'.manipulate(c, m, g)
end end

-- c-a to toggle bool, increment version, etc
u.pack('monaqa/dial.nvim')
local a = require'dial.augend'
require'dial.config'.augends:register_group {
  default = {
    a.integer.alias.decimal,
    a.constant.alias.bool,
    a.constant.new { elements = {'✅', '❌'} },
    a.constant.new { elements = {'ON', 'OFF'} },
    a.hexcolor.new { case = "lower" },
    a.semver.alias.semver,
    a.misc.alias.markdown_header,
  }
}

u.nmap('<c-a>',  get_map('increment','normal'), 'Increment (dial)')
u.nmap('<c-x>',  get_map('decrement','normal'), 'Decrement (dial)')
u.nmap('g<c-a>', get_map('increment','gnormal'), 'Increment (g) (dial)')
u.nmap('g<c-x>', get_map('decrement','gnormal'), 'Decrement (g) (dial)')
u.vmap('<c-a>',  get_map('increment','visual'),  'Increment (dial)')
u.vmap('<c-x>',  get_map('decrement','visual'),  'Decrement (dial)')
u.vmap('g<c-a>', get_map('increment','gvisual'), 'Increment (g) (dial)')
u.vmap('g<c-x>', get_map('decrement','gvisual'), 'Decrement (g) (dial)')
