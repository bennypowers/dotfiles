return { 'nvim-tree/nvim-web-devicons',
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
        name = "JavaScript",
      },
      ts = {
        icon = 'ﯤ',
        color = "#519aba",
        cterm_color = "67",
        name = "TypeScript",
      },
      cjs = {
        icon = '',
        color = '#5FA04E',
        name = 'CommonJS'
      },
      njk = {
        icon = '',
        color = '#3d8137',
        name = 'Nunjucks',
      },
      webc = {
        icon = '',
        color = '#ffa07a',
        name = 'WebC',
      },
    },
  },
}
