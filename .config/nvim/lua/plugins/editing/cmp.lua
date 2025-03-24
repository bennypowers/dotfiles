local filetype_extensions = {
  css = { 'css', 'scss' },
  html = { 'javascript', 'css', 'graphql', 'json', 'svg' },
  svg = { 'css', 'html' },
  javascript = { 'html', 'css', 'graphql', 'svg' },
  typescript = { 'html', 'css', 'graphql', 'svg' },
  markdown = {
    'lua',
    'json',
    'html',
    'svg',
    'yaml',
    'css',
    'typescript',
    'javascript',
  }
}

-- 📎 Completions and Snippets
return {

  { 'L3MON4D3/LuaSnip',
    enabled = true,
    version = '2',
    build = 'make install_jsregexp',
    config = function()
      local ls = require'luasnip'
      ls.config.setup {
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
        -- ft_func = require 'luasnip.extras.filetype_functions'.from_pos_or_filetype,
        ft_func = require 'luasnip.extras.filetype_functions'.from_pos,
        load_ft_func = require 'luasnip.extras.filetype_functions'.extend_load_ft(filetype_extensions),
      }
      require 'luasnip.loaders.from_lua'.lazy_load()
      require 'luasnip.loaders.from_snipmate'.lazy_load {
        paths =  { '~/.config/nvim/snippets' },
        fs_event_providers = { libuv = true },
      }
      for ft, extensions in pairs(filetype_extensions) do
        if #ft > 0 then
          ls.filetype_extend(ft, extensions)
        end
      end
    end
  },

  { 'hrsh7th/nvim-cmp',
    enabled = true,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- language-server-based completions
      'hrsh7th/cmp-nvim-lua', -- lua
      'hrsh7th/cmp-calc', -- math
      'hrsh7th/cmp-buffer', -- buffer contents completion
      'hrsh7th/cmp-path', -- path completions
      'hrsh7th/cmp-emoji', -- ok boomer
      'hrsh7th/cmp-cmdline', -- cmdline completions
      'hrsh7th/cmp-nvim-lsp-signature-help', -- ffffunction
      'saadparwaiz1/cmp_luasnip', -- completion engine
      'ray-x/cmp-treesitter',
      'onsails/lspkind-nvim',
      'lukas-reineke/cmp-under-comparator', -- _afterOthers
      'mtoohey31/cmp-fish', -- 🐟
      { 'David-Kunz/cmp-npm', opts = {} }, -- npm package versions
      { 'petertriho/cmp-git', -- autocomplete git issues
        opts = {
        remotes = { 'upstream', 'origin', 'fork' },
        enableRemoteUrlRewrites = true,
      } },
      { 'KadoBOT/cmp-plugins', -- plugin names
        opts = { files = { 'lua/plugins.*\\.lua' } } },
    },

    version = false,

    lazy = true,

    event = { 'InsertEnter', 'CmdlineEnter' },

    opts = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
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
            local kind = require 'lspkind'.cmp_format({ mode = 'symbol_text', maxwidth = 50 })(entry, vim_item)
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
            { name = 'luasnip', option = { show_autosnippets = true } },
            { name = 'nvim_lsp' },
            { name = 'nvim_lsp_signature_help' },
            { name = 'treesitter' },
            { name = 'buffer', keyword_length = 3 },
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
          { name = 'cmdline' },
        }),
      })

      cmp.setup.filetype('fish', {
        sources = cmp.config.sources({
          { name = 'luasnip', option = { show_autosnippets = true } },
          { name = 'fish' },
          { name = 'buffer' },
          { name = 'calc' },
          { name = 'emoji' },
        })
      })

      cmp.setup.filetype({ 'html', 'svg' }, {
        sources = cmp.config.sources({
        { name = 'luasnip', option = { show_autosnippets = true } },
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'treesitter' },
        { name = 'buffer', keyword_length = 3 },
        })
      })

      cmp.setup.filetype({ 'css', 'scss' }, {
        sources = cmp.config.sources({
        { name = 'luasnip', option = { show_autosnippets = true } },
        { name = 'nvim_lsp' },
        { name = 'treesitter' },
        { name = 'buffer', keyword_length = 3 },
        })
      })

      cmp.setup.filetype({ 'javascript', 'typescript', 'eruby'  }, {
        sources = cmp.config.sources({
          { name = 'luasnip', option = { show_autosnippets = true } },
          { name = 'nvim_lsp', entry_filter = function(entry, ctx)
              ctx = require'cmp.config.context'
              -- only show emmet snippets in lit-like templates
              if (require 'cmp.types'.lsp.CompletionItemKind[entry:get_kind()] == 'Snippet'
                and entry.source:get_debug_name() == 'nvim_lsp:emmet_ls') then
                return ctx.in_treesitter_capture('lit_html')
              else
                return true
              end
            end },
          { name = 'nvim_lsp_signature_help' },
          { name = 'treesitter' },
          { name = 'path' },
          { name = 'buffer', keyword_length = 3 },
          { name = 'calc' },
          { name = 'emoji' },
        })
      })

      cmp.setup.filetype({ 'json', 'jsonc' }, {
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip', option = { show_autosnippets = true } },
          { name = 'npm', keyword_length = 2 },
          { name = 'buffer' },
          { name = 'calc' },
          { name = 'emoji' },
        })
      })

      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'git' },
          { name = 'buffer' },
        })
      })

      cmp.setup.filetype('lua', {
        sources = cmp.config.sources({
          { name = 'luasnip', option = { show_autosnippets = true } },
          { name = 'plugins' },
          { name = 'nvim_lua' },
          { name = 'buffer' },
          { name = 'calc' },
          { name = 'emoji' },
        })
      })

      local function choice_next()
        if luasnip.choice_active() then
          return luasnip.change_choice(1)
        end
      end

      local function choice_prev()
        if luasnip.choice_active() then
          return luasnip.change_choice(-1)
        end
      end

      -- feel free to change the keys to new ones, those are just my current mappings
      vim.keymap.set('i', '<C-f>', choice_next, { noremap = true })
      vim.keymap.set('s', '<C-f>', choice_next, { noremap = true })
      vim.keymap.set('i', '<C-d>', choice_prev, { noremap = true })
      vim.keymap.set('s', '<C-d>', choice_prev, { noremap = true })

    end
  }
}
