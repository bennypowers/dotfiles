return { 'RRethy/vim-illuminate',
  enabled = true,
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  event = { 'CursorMoved', 'InsertLeave' },
  config = function()
    require'illuminate'.configure {
      filetypes_denylist = {
        'alpha',
        'neo-tree',
        'neo-tree-popup',
        'Telescope',
        'telescope',
      }
    }

    vim.cmd[[
      hi clear IlluminatedWordText
      hi clear IlluminatedWordRead
      hi clear IlluminatedWordWrite
      hi link IlluminatedWordText CursorLine
      hi link IlluminatedWordRead CursorLine
      hi link IlluminatedWordWrite CursorLine
      hi illuminatedCurWord cterm=italic gui=italic
    ]]
  end
}
