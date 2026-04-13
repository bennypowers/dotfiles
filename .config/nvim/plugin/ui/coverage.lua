local u = require'utils'
u.pack(
  'nvim-lua/plenary.nvim',
  'andythigpen/nvim-coverage'
)

require'coverage'.setup {
  auto_reload = true,
  coverage_file = 'coverage/lcov.info',
}
