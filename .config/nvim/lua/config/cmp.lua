local cmp = require 'cmp'
local lspkind = require 'lspkind'
local luasnip = require 'luasnip'
local can_npm, cmp_npm = pcall(require, 'cmp-npm')

local types = require 'luasnip.util.types'
luasnip.config.setup {
  history = true,
  native_menu = true,
  updateevents = 'TextChanged,TextChangedI',
  enable_autosnippets = true,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "●", "GruvboxOrange" } }
      }
    }
  },

  ft_func = require 'luasnip.extras.filetype_functions'.from_pos_or_filetype,
  load_ft_func = require 'luasnip.extras.filetype_functions'.extend_load_ft {
    markdown = { 'lua', 'json', 'html', 'yaml', 'css', 'typescript', 'javascript' },
    html = { 'javascript', 'css', 'graphql', 'json' },
    javascript = { 'html', 'css', 'graphql' },
    typescript = { 'html', 'css', 'graphql' },
  },

}

require 'luasnip.loaders.from_snipmate'.lazy_load { paths = "~/.config/nvim/snippets" }
require 'luasnip.loaders.from_lua'.lazy_load()
require 'luasnip.loaders.from_vscode'.lazy_load { paths = {
  "~/Developer/redhat-ux/red-hat-design-tokens/vscode"
} }

vim.keymap.set({ 'i', 's' }, '<c-j>', function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end)

vim.keymap.set({ 'i', 's' }, '<c-k>', function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end)

vim.keymap.set('i', '<c-l>', function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end)

if can_npm then cmp_npm.setup() end

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ['<C-S-Space>'] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ['<C-y>'] = cmp.mapping.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
    ['<CR>'] = function(fallback)
      if cmp.visible() then
        -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        cmp.confirm { select = true }
      else
        fallback() -- If you are using vim-endwise, this fallback function will be behaive as the vim-endwise.
      end
    end,
  },

  sources = cmp.config.sources({
    { name = 'luasnip', option = { use_show_condition = false } },
  }, {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
  }, {
    { name = 'treesitter' },
    { name = 'buffer', keyword_length = 3 },
  }, {
    { name = 'nvim_lua' },
    { name = 'npm', keyword_length = 4 },
    { name = 'fish' },
    { name = 'calc' },
    { name = 'emoji' },
  }),

  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      require 'cmp-under-comparator'.under,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
    }),
  },

  experimental = {
    ghost_text = true,
  },
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' },
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-- If you want insert `(` after select function or method item
local autopairs_loaded, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
if autopairs_loaded then
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
end
