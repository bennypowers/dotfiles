local function load(mod)
  package.loaded[mod] = nil
  return require(mod)
end

pcall(load, 'impatient')

-- disable some built-in plugins
vim.g.loaded_netrw       = 1
vim.g.loaded_matchparen  = 1
vim.g.loaded_netrwPlugin = 1

vim.g.termguicolors = true
vim.g.mapleader     = ' '
vim.env.BASH_ENV    = '~/.config/bashrc'

vim.opt.backspace      = 'indent,eol,start'
vim.opt.colorcolumn    = '100'
vim.opt.completeopt    = 'menu,menuone,noselect'
vim.opt.cursorcolumn   = true
vim.opt.cursorline     = true
vim.opt.encoding       = 'UTF-8'
vim.opt.expandtab      = true
vim.opt.laststatus     = 3
vim.opt.linebreak      = true
vim.opt.list           = true
vim.opt.mouse          = 'a'
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.pastetoggle    = '<F10>'
vim.opt.shiftwidth     = 2
vim.opt.softtabstop    = 2
vim.opt.tabstop        = 2
vim.opt.termguicolors  = true
vim.opt.virtualedit    = 'block,onemore'
vim.opt.wrap           = false
vim.opt.foldlevel      = 20
vim.opt.foldmethod     = 'expr'
vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
vim.opt.shell          = 'bash'

local jid = vim.fn.jobstart { 'git', 'rev-parse', '--git-dir' }
local ret = vim.fn.jobwait { jid }[1]
if ret > 0 then
  vim.env.GIT_DIR = vim.fn.expand '~/.cfg'
  vim.env.GIT_WORK_TREE = vim.fn.expand '~'
end

if vim.g.started_by_firenvim then
  vim.cmd [[source ~/.config/nvim/config/firenvim.vim]]
  vim.g.auto_session_enabled = false
  vim.opt.laststatus = 0
  vim.opt.showtabline = 0
  vim.opt.guifont = 'FiraCode_Nerd_Font'
  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'github.com_*.txt',
    command = 'set filetype=markdown'
  })
end

load 'format' -- Polyfill `vim.lsp.buf.format` from neovim 0.8
load 'plugins'
load 'aucmds'

-- local function highlight_repeats()
--   local line_counts = {}
--   local line_num = vim.a.firstline
--   while line_num <= vim.a.lastline do
--     local line_text = vim.fn.getline(line_num)
--     if #line_text > 0 then
--       line_counts[line_text] = (line_counts[line_text] or 0) + 1
--     end
--     line_num = line_num + 1
--   end
-- end

-- vim.cmd[[
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
-- ]]
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
