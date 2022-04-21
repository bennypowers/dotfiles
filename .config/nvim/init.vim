let mapleader = " "
let $BASH_ENV = "~/.config/bashrc"
let g:loaded_matchparen=1
let g:VM_default_mappings = 0
let g:VM_maps = {}

set backspace=indent,eol,start
set colorcolumn=100
set completeopt=menu,menuone,noselect
set cursorcolumn
set cursorline
set encoding=UTF-8
set expandtab
set laststatus=3
set linebreak
set list
set mouse=a
set nocompatible
set number
set pastetoggle=<F10>
set relativenumber
set shiftwidth=2
set softtabstop=2
set tabstop=2
set termguicolors
set virtualedit=block,onemore
set nowrap
set foldlevel=20
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set shell=bash

filetype off
filetype plugin indent on

lua << EOF
  local jid = vim.fn.jobstart({ "git", "rev-parse", "--git-dir" })
  local ret = vim.fn.jobwait({jid})[1]
  if ret > 0 then
      vim.env.GIT_DIR = vim.fn.expand("~/.cfg")
      vim.env.GIT_WORK_TREE = vim.fn.expand("~")
  end
EOF

if exists('g:started_by_firenvim')
  source ~/.config/nvim/config/firenvim.vim
elseif has('gui_vimr')
  source ~/.config/nvim/config/background.vim
endif

au BufNewFile,BufRead *.njk set ft=jinja

source ~/.config/nvim/config/scratch-capture.vim

colorscheme duskfox

lua require'plugins'

augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua,~/.config/nvim/lua/config/*,~/.config/nvim/lua/setup/* source <afile> | PackerCompile
augroup end

function! HighlightRepeats() range
  let lineCounts = {}
  let lineNum = a:firstline
  while lineNum <= a:lastline
    let lineText = getline(lineNum)
    if lineText != ""
      let lineCounts[lineText] = (has_key(lineCounts, lineText) ? lineCounts[lineText] : 0) + 1
    endif
    let lineNum = lineNum + 1
  endwhile
  exe 'syn clear Repeat'
  for lineText in keys(lineCounts)
    if lineCounts[lineText] >= 2
      exe 'syn match Repeat "^' . escape(lineText, '".\^$*[]') . '$"'
    endif
  endfor
endfunction

command! -range=% HighlightRepeats <line1>,<line2>call HighlightRepeats()

" Edge motion
"
" Jump to the next or previous line that has the same level or a lower
" level of indentation than the current line.
"
" exclusive (bool): true: Motion is exclusive
" false: Motion is inclusive
" fwd (bool): true: Go to next line
" false: Go to previous line
" lowerlevel (bool): true: Go to line with lower indentation level
" false: Go to line with the same indentation level
" skipblanks (bool): true: Skip blank lines
" false: Don't skip blank lines
function! NextIndent(exclusive, fwd, lowerlevel, skipblanks)
  let line = line('.')
  let column = col('.')
  let lastline = line('$')
  let indent = indent(line)
  let stepvalue = a:fwd ? 1 : -1
  while (line > 0 && line <= lastline)
    let line = line + stepvalue
    if ( ! a:lowerlevel && indent(line) == indent ||
          \ a:lowerlevel && indent(line) < indent)
      if (! a:skipblanks || strlen(getline(line)) > 0)
        if (a:exclusive)
          let line = line - stepvalue
        endif
        exe line
        exe "normal " column . "|"
        return
      endif
    endif
  endwhile
endfunction

" Moving back and forth between lines of same or lower indentation.
nnoremap <silent><M-]>  :call NextIndent(0, 1, 0, 1)<CR>
nnoremap <silent><M-[>  :call NextIndent(0, 0, 0, 1)<CR>
vnoremap <silent> [h    <Esc>:call NextIndent(0, 0, 0, 1)<CR>m'gv''
vnoremap <silent> ]j    <Esc>:call NextIndent(0, 1, 0, 1)<CR>m'gv''
vnoremap <silent> [h    <Esc>:call NextIndent(0, 0, 1, 1)<CR>m'gv''
vnoremap <silent> ]j    <Esc>:call NextIndent(0, 1, 1, 1)<CR>m'gv''
onoremap <silent> [h    :call NextIndent(0, 0, 0, 1)<CR>
onoremap <silent> ]j    :call NextIndent(0, 1, 0, 1)<CR>
onoremap <silent> [h    :call NextIndent(1, 0, 1, 1)<CR>
onoremap <silent> ]j    :call NextIndent(1, 1, 1, 1)<CR>
