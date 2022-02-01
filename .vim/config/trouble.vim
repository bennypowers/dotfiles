lua << EOF
local trouble = require("trouble")
trouble.setup {
  auto_open = true, -- automatically open the list when you have diagnostics
  auto_close = false, -- automatically close the list when you have no diagnostics

  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
}
EOF
