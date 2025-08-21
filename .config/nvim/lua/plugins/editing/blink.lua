return { 'saghen/blink.cmp',
  -- version = '1.*',
  version = '*',
  enabled = true,
  -- branch = 'fix/luasnip-hidden-snippet',
  dependencies = { 'L3MON4D3/LuaSnip' },
  opts_extend = { 'sources.default' },
  ---@type blink.cmp.Config
  opts = {
    snippets = { preset = 'luasnip', },
    sources = {
      default = {
        'lsp',
        'path',
        'snippets',
        'buffer',
      },
    },
    fuzzy = {
      implementation = 'prefer_rust_with_warning',
      sorts = {
        'score',
        'kind',
        'sort_text',
        'label',
      }
    },
    keymap = {
      preset = 'enter',
    },
    signature = {
      enabled = true,
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
      list = {
        selection = {
          preselect = false,
        },
      },
      menu = {
        draw = {
          columns = {
            { 'kind_icon' },
            { 'label', 'label_description', gap = 1 },
            { 'kind'}
          },
        }
      },
      ghost_text = {
        enabled = true,
      },
    },
  },
}
