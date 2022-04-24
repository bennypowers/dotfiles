return function()

  local cmp = require'cmp'
  local lspkind = require'lspkind'
  local luasnip = require'luasnip'
  local cmp_npm = require'cmp-npm'

  cmp_npm.setup()

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    mapping = {
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      ["<C-S-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
      ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
      ['<CR>'] = function(fallback)
        if cmp.visible() then
          -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          cmp.confirm { select = true }
        else
          fallback() -- If you are using vim-endwise, this fallback function will be behaive as the vim-endwise.
        end
      end,
    },

    sources = cmp.config.sources {
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'nvim_lua' },
      { name = 'npm', keyword_length = 4 },
      { name = 'calc' },
      { name = 'emoji' },
      { name = 'luasnip' },
    }, {
      { name = "buffer", keyword_length = 5 },
    },

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

  cmp.setup.filetype('fish', {
    sources = cmp.config.sources({
      { name = 'fish' },
    }, {
      { name = 'buffer' },
    })
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

  require'luasnip.loaders.from_snipmate'.lazy_load()
end
