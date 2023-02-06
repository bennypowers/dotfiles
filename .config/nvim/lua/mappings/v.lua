local U = require 'utils'

local function vmap(lhs, rhs, desc)
  vim.keymap.set('v', lhs, rhs, { desc = desc })
end

vmap('F',        U.find_selection,                    'Find selection in project')
vmap('fg',       U.find_selection,                    'Find selection in project')
vmap('rn',       vim.lsp.buf.rename,                  'Rename refactor')
