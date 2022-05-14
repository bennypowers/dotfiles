require 'mini.comment'.setup()
require 'mini.pairs'.setup()
require 'mini.surround'.setup {
  custom_surroundings = {
    ['('] = { output = { left = '( ', right = ' )' } },
    ['['] = { output = { left = '[ ', right = ' ]' } },
    ['{'] = { output = { left = '{ ', right = ' }' } },
    ['<'] = { output = { left = '< ', right = ' >' } },
  },
  mappings = {
    add = 'ys',
    delete = 'ds',
    find = '',
    find_left = '',
    highlight = '',
    replace = 'cs',
    update_n_lines = '',
  },
  search_method = 'cover_or_next',
}
-- Remap adding surrounding to Visual mode selection
vim.api.nvim_set_keymap('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { noremap = true })
-- Make special mapping for "add surrounding for line"
vim.api.nvim_set_keymap('n', 'yss', 'ys_', { noremap = false })

require 'mini.trailspace'.setup()
vim.api.nvim_create_augroup('MiniTrailspaceOnSave', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'MiniTrailspaceOnSave',
  pattern = { '*.lua' },
  callback = function()
    require 'mini.trailspace'.trim()
  end
})

-- require'mini.indentscope'.setup {
--   symbol = '|',
--   draw = {
--     delay = 0,
--     animation = require'mini.indentscope'.gen_animation('none'),
--   }
-- }
