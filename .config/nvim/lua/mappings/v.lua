local U = require 'utils'

return {
  F  = { U.find_selection, 'Find selection in project' },
  fg = { U.find_selection, 'Find selection in project' },

  ['<leader>'] = {
    ['<c-d>'] = { '<Plug>(VM-Find-Subword-Under)<cr>', 'Find occurrence of subword under cursor' },
    r = {
      name = 'rename/rotate',
      c = {
        name        = 'caser',
        _           = { '<Plug>CaserVSnakeCase<cr>', 'snake_case' },
        ['-']       = { '<Plug>CaserVKebabCase<cr>', 'dash-case' },
        ['.']       = { '<Plug>CaserVDotCase<cr>', 'dot.case' },
        ['<space>'] = { '<Plug>CaserVSpaceCase<cr>', 'space case' },
        c           = { '<Plug>CaserVCamelCase<cr>', 'camelCase' },
        K           = { '<Plug>CaserVTitleKebabCase<cr>', 'Upper-Dash-Case' },
        p           = { '<Plug>CaserVMixedCase<cr>', 'PascalCase' },
        s           = { '<Plug>CaserVSentenceCase<cr>', 'Sentence case' },
        t           = { '<Plug>CaserVTitleCase<cr>', 'Title Case' },
        u           = { '<Plug>CaserVUpperCase<cr>', 'UPPER_SNAKE' },
        U           = { '<Plug>CaserVUpperCase<cr>', 'UPPER_SNAKE' },
      },

      o = {
        name = 'colours',
        c    = { U.cycle_color, 'Cycle colour format' },
        h    = { U.format_hsl, 'Format color as hsl()' },
      },

      n = { vim.lsp.buf.rename, 'Rename refactor' },

    }
  }

}
