-- 🌳 Syntax
return {
  { 'nvim-treesitter/nvim-treesitter-textobjects', dependencies = 'nvim-treesitter/nvim-treesitter'},
  { 'nvim-treesitter/nvim-treesitter',
  enabled = true,
  dev = false,
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
        'bash', 'fish',
        'c', 'cmake', 'cpp',
        -- 'comment',
        'commonlisp',
        'css', 'scss',
        'diff',
        'dockerfile',
        'go',
        'graphql',
        'haskell',
        'html',
        'http',
        'javascript', 'jsdoc', 'typescript',
        'json', 'json5',
        'latex',
        'lua',
        'make',
        'markdown', 'markdown_inline',
        'ninja',
        'php', 'phpdoc',
        'python',
        'query', 'scheme',
        'regex',
        'ruby',
        'rust',
        'teal',
        'todotxt',
        'toml',
        'vim', 'vimdoc',
        'yaml',
      },

      highlight = {
        enable = true,
        custom_captures = {
          ['(method_signature name:(property_identifier)'] = 'BP_TSMethodSignature',
        },
      },

      incremental_selection = {
        enable = true,
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          include_surrounding_whitespace = true,
          keymaps = {
            ['aa'] = '@attribute.outer',
            ['ia'] = '@attribute.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['ab'] = '@block.outer',
            ['ib'] = '@block.inner',
            ['a*'] = '@comment.outer',
            ['i*'] = '@comment.inner',
          },
          peek_definition_code = {
            ['<leader>df'] = '@function.outer',
            ['<leader>dF'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['gsa'] = '@attribute.outer',
          },
          swap_previous = {
            ['gSa'] = '@attribute.outer',
          }
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
          'webc',
        }
      },
    }
  end,
} }

