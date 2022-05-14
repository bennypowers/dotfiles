local icons = require 'nvim-web-devicons'
icons.setup {
  override = {
    md = {
      icon = "",
      color = "#519aba",
      cterm_color = "67",
      name = "Markdown",
    },
    node_modules = {
      icon = "",
      color = "#90a959",
      name = "NodeModules",
    },
    ts = {
      icon = 'ﯤ',
      color = "#519aba",
      cterm_color = "67",
      name = "Ts",
    },
  }
}
icons.set_icon {
  ['.github'] = {
    icon = '',
    name = "GitHub",
  },
  ['tsconfig.json'] = {
    icon = "",
    color = "#519aba",
    name = "TSConfigJson"
  },
}
