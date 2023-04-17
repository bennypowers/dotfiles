-- 🌳 Syntax
return { 'bennypowers/nvim-treesitter',
  dev = true,
  -- branch = 'feat/markdown/aliases',
  build = ':TSUpdate',
  config = function()
    local parser_install_dir = vim.fn.expand'~/.local/share/treesitter';
    vim.opt.runtimepath:append(parser_install_dir)

    local parser_config = require 'nvim-treesitter.parsers'.get_parser_configs()

    parser_config.css = {
      install_info = {
        url = "https://github.com/bennypowers/tree-sitter-css",
        branch = 'fix/parse/slotted',
        files = { "src/parser.c", "src/scanner.c" },
      },
      maintainers = { "@TravonteD" },
    }

    parser_config.scss = {
      install_info = {
        url = "https://github.com/bennypowers/tree-sitter-scss",
        branch = 'fix/parse/pseudo-element-args',
        files = { "src/parser.c", "src/scanner.c" },
      },
      maintainers = { "@elianiva" },
    }

    require 'nvim-treesitter.configs'.setup {
      parser_install_dir = parser_install_dir,
      ensure_installed = {
        'bash',
        'c',
        'cmake',
        'comment',
        'commonlisp',
        'cpp',
        'css',
        'diff',
        'dockerfile',
        'fish',
        'go',
        'graphql',
        'haskell',
        'html',
        'http',
        'javascript',
        'jsdoc',
        'json',
        'json5',
        'latex',
        'lua',
        'make',
        'markdown',
        'markdown_inline',
        'php',
        'phpdoc',
        'python',
        'regex',
        'ruby',
        'rust',
        'scheme',
        'scss',
        'teal',
        'todotxt',
        'toml',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      },

      highlight = {
        enable = true,
        custom_captures = {
          ["(method_signature name:(property_identifier)"] = "BP_TSMethodSignature",
        },
      },

      incremental_selection = {
        enable = true,
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["aa"] = "@attribute.outer",
            ["ia"] = "@attribute.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["a*"] = "@comment.outer",
            ["i*"] = "@comment.inner",
          },
          peek_definition_code = {
            ["<leader>df"] = "@function.outer",
            ["<leader>dF"] = "@class.outer",
          },
        }
      },

      indent = {
        enable = true,
      },

      endwise = {
        enable = true,
      },

      autotag = {
        enable = true,
        filetypes = {
          'html',
          'njk', 'jinja', 'nunjucks',
          'js', 'javascript',
          'jsx', 'javascriptreact',
          'md', 'markdown',
          'svelte',
          'ts', 'typescript',
          'tsx', 'typescriptreact',
          'vue',
        }
      },

      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = 'o',
          toggle_hl_groups = 'i',
          toggle_injected_languages = 't',
          toggle_anonymous_nodes = 'a',
          toggle_language_display = 'I',
          focus_language = 'f',
          unfocus_language = 'F',
          update = 'R',
          goto_node = '<cr>',
          show_help = '?',
        },
      },
    }
  end,
}

