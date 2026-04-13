local u = require'utils'

u.pack(
  'ziontee113/query-secretary', -- help writing treesitter queries
  'windwp/nvim-ts-autotag', -- close HTML tags, but using treesitter
  'RRethy/nvim-treesitter-endwise', -- append `end` in useful places
  'nvim-treesitter/nvim-treesitter-textobjects'
)

local to = require'nvim-treesitter-textobjects'

to.setup {
  select = {
    lookahead = true,
    include_surrounding_whitespace = true,
  },
  swap = { enable = true }
}

local select = require'nvim-treesitter-textobjects.select'
local swap = require'nvim-treesitter-textobjects.swap'

local function s(class)
  return function()
    select.select_textobject(class, 'textobjects')
  end
end

u.xomap('aa',s('@attribute.outer'))
u.xomap('ia',s('@attribute.inner'))
u.xomap('af',s('@function.outer'))
u.xomap('if',s('@function.inner'))
u.xomap('ac',s('@class.outer'))
u.xomap('ic',s('@class.inner'))
u.xomap('ab',s('@block.outer'))
u.xomap('ib',s('@block.inner'))
u.xomap('a*',s('@comment.outer'))
u.xomap('i*',s('@comment.inner'))

u.nmap('gsan', function() swap.swap_next('@attribute.outer') end, 'Swap next attribute')
u.nmap('gsap', function() swap.swap_previous('@attribute.outer') end, 'Swap previous attribute')
