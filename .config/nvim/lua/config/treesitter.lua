return function()
  require'nvim-treesitter.configs'.setup {
    ensure_installed = {
      'bash',
      'c',
      'cmake',
      'comment',
      'commonlisp',
      'cpp',
      'css',
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
      -- 'tree-sitter-query',
      'typescript',
      'vim',
      'yaml',
    },
    highlight = { enable = true },
    incremental_selection = { enable = true },
    textobjects = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    indent = { enable = true },
    endwise = { enable = true },
    autotag = { enable = true, filetypes = {
      'html',
      'njk', 'jinja', 'nunjucks',
      'js', 'javascript',
      'jsx', 'javascriptreact',
      'md', 'markdown',
      'svelte',
      'ts','typescript',
      'tsx','typescriptreact',
      'vue',
    } },
  }

  require'nvim-treesitter.configs'.setup {
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
    highlight = {
      custom_captures = {
        ["(method_signature name:(property_identifier)"] = "BP_TSMethodSignature"
      },
    },
  }

end
