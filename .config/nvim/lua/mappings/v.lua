local U = require 'utils'

return {
  ['<leader>'] = {
    F         = { U.spectre_open_visual, 'Find/replace selection in project' },
    ['<c-d>'] = { '<Plug>(VM-Find-Subword-Under)<cr>', 'Find occurrence of subword under cursor' },
  }
}
