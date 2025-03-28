local function next_choice()
  local luasnip = require'luasnip'
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end

local function prev_choice()
  local luasnip = require'luasnip'
  if luasnip.choice_active() then
    luasnip.change_choice(-1)
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end

local function pick_choice()
  require'luasnip.extras.select_choice'()
end

return { 'saghen/blink.cmp',
  version = '1.*',
  branch = 'fix/luasnip-hidden-snippet',
  dependencies = { 'L3MON4D3/LuaSnip' },
  opts_extend = { 'sources.default' },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'enter',
      ['<c-e>'] = { pick_choice },
      ['<c-j>'] = { next_choice },
      ['<c-k>'] = { prev_choice },
    },
    snippets = {
      preset = 'luasnip',
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
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = {
      implementation = 'prefer_rust_with_warning',
    },
  },
}
