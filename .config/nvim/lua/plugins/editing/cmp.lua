-- 📎 Completions and Snippets
return { 'hrsh7th/nvim-cmp',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/cmp-nvim-lsp', -- language-server-based completions
    'hrsh7th/cmp-nvim-lua', -- lua
    'hrsh7th/cmp-calc', -- math
    'hrsh7th/cmp-buffer', -- buffer contents completion
    'hrsh7th/cmp-path', -- path completions
    'hrsh7th/cmp-emoji', -- ok boomer
    'hrsh7th/cmp-cmdline', -- cmdline completions
    'hrsh7th/cmp-nvim-lsp-signature-help', -- ffffunction
    'petertriho/cmp-git', -- autocomplete git issues
    'ray-x/cmp-treesitter',
    'David-Kunz/cmp-npm', -- npm package versions
    'KadoBOT/cmp-plugins', -- plugin names
    'lukas-reineke/cmp-under-comparator', -- _afterOthers
    'mtoohey31/cmp-fish', -- 🐟
    { 'L3MON4D3/LuaSnip', version = '1', priority = 200 },
    { 'saadparwaiz1/cmp_luasnip', priority = 100 }, -- completion engine
  },

  lazy = true,

  event = { 'InsertEnter' },

  config = function()
    local cmp = require 'cmp'
    local lspkind = require 'lspkind'
    local luasnip = require 'luasnip'

    luasnip.config.setup {
      history = true,
      native_menu = true,
      updateevents = 'TextChanged,TextChangedI',
      enable_autosnippets = true,
      ext_opts = {
        [require 'luasnip.util.types'.choiceNode] = {
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

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      mapping = {
        ['<c-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<c-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<c-s-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<c-y>'] = cmp.mapping.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<c-e>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),

        ['<c-j>'] = cmp.mapping(function()
          --  desc = 'Expand snippet or jump to next slot'
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),

        ['<c-k>'] = cmp.mapping(function()
          -- desc = 'Jump to previous slot'
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),

        ['<c-l>'] = cmp.mapping(function()
          -- desc = 'Change snippet choice'
          if luasnip.choice_active() then
            luasnip.change_choice(1)
          end
        end, { 'i', 's' }),

        ['<down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
        ['<up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
        ['<cr>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            cmp.confirm { select = true }
          else
            fallback() -- If you are using vim-endwise, this fallback function will be behaive as the vim-endwise.
          end
        end, { 'i', 's' }),
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

      window = {
        completion = {
          winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
          col_offset = -3,
          side_padding = 0,
        },
      },

      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        -- fields = { "kind", "abbr" },
        format = function(entry, vim_item)
          local kind = lspkind.cmp_format({ mode = 'symbol_text', maxwidth = 50 })(entry, vim_item)
          local strings = vim.split(kind.kind, '%s', { trimempty = true })
          kind.kind = ' ' .. strings[1] .. ' '
          -- kind.menu = "    (" .. strings[2] .. ")"
          kind.menu = ({
            buffer = '🧹',
            nvim_lsp = '🔮',
            luasnip = '✂️',
            nvim_lua = '🌙',
            path = '怒',
            treesitter = '🌴',
          })[entry.source.name]
          return kind
        end,
      },

      experimental = {
        ghost_text = true,
      },

      sources = cmp.config.sources({
          { name = 'luasnip' },
        }, {
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
        }, {
          { name = 'treesitter' },
          { name = 'buffer', keyword_length = 3 },
        }, {
          { name = 'path' },
          { name = 'calc' },
          { name = 'emoji' },
      }),
    }

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'buffer' },
      }),
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
    })

    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'git' },
      }, {
        { name = 'buffer' },
      })
    })

    cmp.setup.filetype('lua', {
      sources = cmp.config.sources({
        { name = 'plugins' },
        { name = 'nvim_lua' },
      }, {
        { name = 'buffer' },
      }, {
        { name = 'calc' },
        { name = 'emoji' },
      })
    })

    cmp.setup.filetype('fish', {
      sources = cmp.config.sources({
        { name = 'fish' },
      }, {
        { name = 'buffer' },
      }, {
        { name = 'calc' },
        { name = 'emoji' },
      })
    })

    cmp.setup.filetype('json', {
      sources = cmp.config.sources({
        { name = 'npm', keyword_length = 2 },
      }, {
        { name = 'buffer' },
      }, {
        { name = 'calc' },
        { name = 'emoji' },
      })
    })

    -- If you want insert `(` after select function or method item
    local autopairs_loaded, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
    if autopairs_loaded then
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end

    ---https://github.com/hrsh7th/nvim-cmp/pull/1067/files
    local lit_html_query = vim.treesitter.query.get_query('typescript', 'lit_html')
    local function is_lit_html_template()
      local parser = vim.treesitter.get_parser(0, 'typescript', {})
      local tree = parser:parse()[1]

      local row = unpack(vim.api.nvim_win_get_cursor(0))
      local caps = {}
      for id in lit_html_query:iter_captures(tree:root(), 0, row - 1, row) do
        table.insert(caps, lit_html_query.captures[id])
      end
      return vim.tbl_contains(caps, 'lit_html')
    end

    local kinds = require 'cmp.types'.lsp.CompletionItemKind
    local function is_emmet_snippet(entry)
      return kinds[entry:get_kind()] == 'Snippet'
          and entry.source:get_debug_name() == 'nvim_lsp:emmet_ls'
    end

    local function emmet_in_lit_only(entry, _)
      if (is_emmet_snippet(entry)) then
        return is_lit_html_template()
      else
        return true
      end
    end

    local JS_CONFIG = {
      sources = cmp.config.sources({
        { name = 'luasnip' },
        { name = 'nvim_lsp', entry_filter = emmet_in_lit_only },
        { name = 'nvim_lsp_signature_help' },
      }, {
        { name = 'treesitter' },
        { name = 'path' },
        { name = 'buffer', keyword_length = 3 },
      }, {
        { name = 'calc' },
        { name = 'emoji' },
      })
    }

    cmp.setup.filetype('javascript', JS_CONFIG)
    cmp.setup.filetype('typescript', JS_CONFIG)

    require 'cmp_git'.setup {
      remotes = { 'upstream', 'origin', 'fork' },
      enableRemoteUrlRewrites = true,
    }

    require 'cmp-npm'.setup {}

    require 'cmp-plugins'.setup {
      files = { 'lua/plugins.*\\.lua' }
    }

    require 'luasnip.loaders.from_lua'.lazy_load()

    require 'luasnip.loaders.from_vscode'.lazy_load { paths = {
      '~/Developer/redhat-ux/red-hat-design-tokens/editor/vscode',
    } }

    require 'luasnip.loaders.from_snipmate'.lazy_load { paths = {
      '~/.config/nvim/snippets',
    } }
  end
}
