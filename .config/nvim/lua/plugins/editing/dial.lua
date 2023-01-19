-- c-a to toggle bool, increment version, etc
return { 'monaqa/dial.nvim', lazy = true, keys = { '<c-a>', '<c-x>' }, config = function()

local augend = require'dial.augend'
require'dial.config'.augends:register_group {
  default = {
    augend.constant.new {
      elements = {'true', 'false'},
      word = true,
      cyclic = true,
    },
  }
}

end }

