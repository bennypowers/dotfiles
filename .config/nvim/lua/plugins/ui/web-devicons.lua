local MD   = '';
local GH   = '';
local TS   = '';
local JS   = '';
local HTML = '';
local NODE = '';

return { 'nvim-tree/nvim-web-devicons',
  opts = {
    override = {
      ['.github'] = {
        icon = GH,
        name = "GitHub",
      },
      ['tsconfig.json'] = {
        icon = TS,
        -- color = "#284d5d", -- darker colour for light bg
        color = '#688c9c', -- lighter colour for dark bg
        name = 'TSConfigJson'
      },
      ['.nvmrc'] = {
        icon = NODE,
        color = 'grey',
        name = 'NvmRc'
      },
      -- ['.eslintignore'] = {
      --   icon = ''
      -- },
      node_modules = {
        icon = NODE,
        color = '#90a959',
        name = 'NodeModules',
      },
    },
    override_by_extension = {
      md = {
        icon = MD,
        color = '#519aba',
        cterm_color = '67',
        name = 'Markdown',
      },
      css = {
        icon = '',
        color = '#0074bf',
        name = 'CSS',
      },
      js = {
        icon = JS,
        color = '#f7df1e',
        name = 'JavaScript',
      },
      ts = {
        icon = TS,
        color = '#519aba',
        cterm_color = '67',
        name = 'TypeScript',
      },
      cjs = {
        icon = JS,
        color = '#5FA04E',
        name = 'CommonJS'
      },
      njk = {
        icon = HTML,
        color = '#3d8137',
        name = 'Nunjucks',
      },
      webc = {
        icon = HTML,
        color = '#ffa07a',
        name = 'WebC',
      },
    },
  },
}
