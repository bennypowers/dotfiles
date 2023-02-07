-- pretty folds with previews
return { 'anuvyklack/pretty-fold.nvim',
  dependencies = {
    'anuvyklack/nvim-keymap-amend',
    'anuvyklack/fold-preview.nvim'
  },
  config = function()
    require 'pretty-fold'.setup {
      keep_indentation = false,
      fill_char = '━',
      sections = {
        left = {
          '━ ', function() return string.rep('>', vim.v.foldlevel) end, ' ━┫', 'content', '┣'
        },
        right = {
          '┫ ', 'number_of_folded_lines', ': ', 'percentage', ' ┣━━',
        }
      }
    }

    require 'fold-preview'.setup()
  end,
}
