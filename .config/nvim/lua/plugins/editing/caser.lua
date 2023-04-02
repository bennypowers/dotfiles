-- change case (camel, dash, etc)
return { 'arthurxavierx/vim-caser',
  lazy = true,
  enabled = false,
  keys = {
    { 'gC_',       '<Plug>CaserSnakeCase<cr>',      mode = {'n','v'}, desc = 'snake_case' },
    { 'gC-',       '<Plug>CaserKebabCase<cr>',      mode = {'n','v'}, desc = 'dash-case' },
    { 'gC.',       '<Plug>CaserDotCase<cr>',        mode = {'n','v'}, desc = 'dot.case' },
    { 'gC<space>', '<Plug>CaserSpaceCase<cr>',      mode = {'n','v'}, desc = 'space case' },
    { 'gCc',       '<Plug>CaserCamelCase<cr>',      mode = {'n','v'}, desc = 'camelCase' },
    { 'gCK',       '<Plug>CaserTitleKebabCase<cr>', mode = {'n','v'}, desc = 'Upper-Dash-Case' },
    { 'gCp',       '<Plug>CaserMixedCase<cr>',      mode = {'n','v'}, desc = 'PascalCase' },
    { 'gCs',       '<Plug>CaserSentenceCase<cr>',   mode = {'n','v'}, desc = 'Sentence case' },
    { 'gCt',       '<Plug>CaserTitleCase<cr>',      mode = {'n','v'}, desc = 'Title Case' },
    { 'gCu',       '<Plug>CaserUpperCase<cr>',      mode = {'n','v'}, desc = 'UPPER_SNAKE_CASE' },
    { 'gCU',       '<Plug>CaserUpperCase<cr>',      mode = {'n','v'}, desc = 'UPPER_SNAKE_CASE' },
  },
  init = function ()
    vim.g.caser_no_mappings = 1
  end,
}

