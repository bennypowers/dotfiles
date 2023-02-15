return { 'nvim-tree/nvim-web-devicons',
  name = 'web-devicons',
  opts = {
    override = {
      ['.github'] = {
        icon = '',
        name = "GitHub",
      },
      ['tsconfig.json'] = {
        icon = "",
        -- color = "#284d5d", -- darker colour for light bg
        color = "#688c9c", -- lighter colour for dark bg
        name = "TSConfigJson"
      },
      ['.nvmrc'] = {
        icon = '',
        color = 'grey',
        name = "NvmRc"
      },
      -- ['.eslintignore'] = {
      --   icon = ''
      -- },
      node_modules = {
        icon = "",
        color = "#90a959",
        name = "NodeModules",
      },
    },
    override_by_extension = {
      md = {
        icon = "",
        color = "#519aba",
        cterm_color = "67",
        name = "Markdown",
      },
      js = {
        icon = '',
        color = "#f7df1e",
        name = "Js",
      },
      ts = {
        icon = 'ﯤ',
        color = "#519aba",
        cterm_color = "67",
        name = "Ts",
      },
      cjs = {
        icon = '',
        color = '#5FA04E',
        name = 'Cjs'
      },
      njk = {
        icon = '',
        color = '#3d8137',
        name = 'Njk',
      }
    },
  }
}
