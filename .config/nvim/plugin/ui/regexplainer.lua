local u = require 'utils'

u.pack(
  'edluffy/hologram.nvim',
  'bennypowers/nvim-regexplainer'
)

require 'regexplainer'.setup {
  auto = true,
  display = 'popup',
  debug = false,
  mode = 'graphical',
}
