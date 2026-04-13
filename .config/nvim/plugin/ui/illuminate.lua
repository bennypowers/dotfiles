local u = require'utils'
u.pack 'RRethy/vim-illuminate'

vim.cmd [[
  hi clear IlluminatedWordText
  hi clear IlluminatedWordRead
  hi clear IlluminatedWordWrite
  hi link IlluminatedWordText CursorLine
  hi link IlluminatedWordRead CursorLine
  hi link IlluminatedWordWrite CursorLine
  hi illuminatedCurWord cterm=italic gui=italic
]]
