pcall(require, 'impatient')

-- disable some built-in plugins
vim.g.loaded_netrw        = 1
vim.g.loaded_matchparen   = 1
vim.g.loaded_netrwPlugin  = 1

vim.g.termguicolors       = true
vim.g.mapleader           = " "
vim.env.BASH_ENV          = "~/.config/bashrc"

vim.go.backspace      = 'indent,eol,start'
vim.go.colorcolumn    = 100
vim.go.completeopt    = 'menu,menuone,noselect'
vim.go.cursorcolumn   = true
vim.go.cursorline     = true
vim.go.encoding       = 'UTF-8'
vim.go.expandtab      = true
vim.go.laststatus     = 3
vim.go.linebreak      = true
vim.go.list           = true
vim.go.mouse          = 'a'
vim.go.number         = true
vim.go.pastetoggle    = '<F10>'
vim.go.relativenumber = true
vim.go.shiftwidth     = 2
vim.go.softtabstop    = 2
vim.go.tabstop        = 2
vim.go.termguicolors  = true
vim.go.virtualedit    = 'block,onemore'
vim.go.wrap           = false
vim.go.foldlevel      = 20
vim.go.foldmethod     = 'expr'
vim.go.foldexpr       = 'nvim_treesitter#foldexpr()'
vim.go.shell          = 'bash'

local jid = vim.fn.jobstart({ "git", "rev-parse", "--git-dir" })
local ret = vim.fn.jobwait({jid})[1]
if ret > 0 then
    vim.env.GIT_DIR = vim.fn.expand("~/.cfg")
    vim.env.GIT_WORK_TREE = vim.fn.expand("~")
end

if vim.g.started_by_firenvim then
  vim.cmd[[source ~/.config/nvim/config/firenvim.vim]]
elseif vim.fn.has('gui_vimr') ~= 0 then
  vim.cmd[[source ~/.config/nvim/config/background.vim]]
end

require'plugins'

vim.cmd[[colorscheme duskfox]]

vim.api.nvim_create_augroup('nunjucks_ft', { clear = true })
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = 'nunjucks_ft',
  pattern = '*.njk',
  command = "set ft='jinja'",
})

vim.api.nvim_create_augroup('packer_user_config', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = 'packer_user_config',
  pattern = 'plugins.lua',
  command = 'PackerCompile',
})

-- function! HighlightRepeats() range
--   let lineCounts = {}
--   let lineNum = a:firstline
--   while lineNum <= a:lastline
--     let lineText = getline(lineNum)
--     if lineText != ""
--       let lineCounts[lineText] = (has_key(lineCounts, lineText) ? lineCounts[lineText] : 0) + 1
--     endif
--     let lineNum = lineNum + 1
--   endwhile
--   exe 'syn clear Repeat'
--   for lineText in keys(lineCounts)
--     if lineCounts[lineText] >= 2
--       exe 'syn match Repeat "^' . escape(lineText, '".\^$*[]') . '$"'
--     endif
--   endfor
-- endfunction
--
-- command! -range=% HighlightRepeats <line1>,<line2>call HighlightRepeats()
--
-- " Edge motion
-- "
-- " Jump to the next or previous line that has the same level or a lower
-- " level of indentation than the current line.
-- "
-- " exclusive (bool): true: Motion is exclusive
-- " false: Motion is inclusive
-- " fwd (bool): true: Go to next line
-- " false: Go to previous line
-- " lowerlevel (bool): true: Go to line with lower indentation level
-- " false: Go to line with the same indentation level
-- " skipblanks (bool): true: Skip blank lines
-- " false: Don't skip blank lines
-- function! NextIndent(exclusive, fwd, lowerlevel, skipblanks)
--   let line = line('.')
--   let column = col('.')
--   let lastline = line('$')
--   let indent = indent(line)
--   let stepvalue = a:fwd ? 1 : -1
--   while (line > 0 && line <= lastline)
--     let line = line + stepvalue
--     if ( ! a:lowerlevel && indent(line) == indent ||
--           \ a:lowerlevel && indent(line) < indent)
--       if (! a:skipblanks || strlen(getline(line)) > 0)
--         if (a:exclusive)
--           let line = line - stepvalue
--         endif
--         exe line
--         exe "normal " column . "|"
--         return
--       endif
--     endif
--   endwhile
-- endfunction
--
-- " Moving back and forth between lines of same or lower indentation.
-- nnoremap <silent><M-]>  :call NextIndent(0, 1, 0, 1)<CR>
-- nnoremap <silent><M-[>  :call NextIndent(0, 0, 0, 1)<CR>
-- vnoremap <silent> [h    <Esc>:call NextIndent(0, 0, 0, 1)<CR>m'gv''
-- vnoremap <silent> ]j    <Esc>:call NextIndent(0, 1, 0, 1)<CR>m'gv''
-- vnoremap <silent> [h    <Esc>:call NextIndent(0, 0, 1, 1)<CR>m'gv''
-- vnoremap <silent> ]j    <Esc>:call NextIndent(0, 1, 1, 1)<CR>m'gv''
-- onoremap <silent> [h    :call NextIndent(0, 0, 0, 1)<CR>
-- onoremap <silent> ]j    :call NextIndent(0, 1, 0, 1)<CR>
-- onoremap <silent> [h    :call NextIndent(1, 0, 1, 1)<CR>
-- onoremap <silent> ]j    :call NextIndent(1, 1, 1, 1)<CR>

