-- change case (camel, dash, etc)
return { 'arthurxavierx/vim-caser',
  lazy = true,
  keys = {
    { '<leader>rc_',       '<Plug>CaserSnakeCase<cr>',      desc = 'snake_case' },
    { '<leader>rc-',       '<Plug>CaserKebabCase<cr>',      desc = 'dash-case' },
    { '<leader>rc.',       '<Plug>CaserDotCase<cr>',        desc = 'dot.case' },
    { '<leader>rc<space>', '<Plug>CaserSpaceCase<cr>',      desc = 'space case' },
    { '<leader>rcc',       '<Plug>CaserCamelCase<cr>',      desc = 'camelCase' },
    { '<leader>rcK',       '<Plug>CaserTitleKebabCase<cr>', desc = 'Upper-Dash-Case' },
    { '<leader>rcp',       '<Plug>CaserMixedCase<cr>',      desc = 'PascalCase' },
    { '<leader>rcs',       '<Plug>CaserSentenceCase<cr>',   desc = 'Sentence case' },
    { '<leader>rct',       '<Plug>CaserTitleCase<cr>',      desc = 'Title Case' },
    { '<leader>rcu',       '<Plug>CaserUpperCase<cr>',      desc = 'UPPER_SNAKE_CASE' },
    { '<leader>rcU',       '<Plug>CaserUpperCase<cr>',      desc = 'UPPER_SNAKE_CASE' },
  },
  init = function ()
    vim.g.caser_no_mappings = 1
  end,
}

