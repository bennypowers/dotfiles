set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath

syntax on

set nocompatible
set completeopt=menu,menuone,noselect
set colorcolumn=100
set termguicolors
set encoding=UTF-8
set number
set relativenumber
set backspace=indent,eol,start
set relativenumber
set number
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set laststatus=2
set pastetoggle=<F10>
set virtualedit=block,onemore
set cursorline
set cursorcolumn
set wrap
set linebreak
set list
set mouse=a

set foldlevel=20
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

filetype off
filetype plugin indent on

highlight Comment cterm=italic

let mapleader = " "

if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

if &shell =~# 'fish$'
	set shell=sh
endif

au BufNewFile,BufRead *.njk set ft=jinja

augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end

lua require'plugins'

if exists('g:started_by_firenvim')
  set laststatus=0
  set guifont=Fira_Code_Light_Regular:h22
  au BufEnter github.com_*.txt s  et filetype=markdown
else
  source ~/.config/nvim/config/background.vim
endif

source ~/.config/nvim/config/keybindings.vim
source ~/.config/nvim/config/scratch-capture.vim

