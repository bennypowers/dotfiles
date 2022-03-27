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

let $BASH_ENV = "~/.config/bashrc"
set shell=bash

set foldlevel=20
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

filetype off
filetype plugin indent on

if exists('g:started_by_firenvim')
  source ~/.config/nvim/config/firenvim.vim
elseif has('gui_vimr')
  source ~/.config/nvim/config/background.vim
endif

" if &shell =~# 'fish$'
" 	set shell=sh
" endif

au BufNewFile,BufRead *.njk set ft=jinja

source ~/.config/nvim/config/keybindings.vim
source ~/.config/nvim/config/scratch-capture.vim

colorscheme duskfox

lua require'plugins'

augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua,~/.config/nvim/lua/config/*,~/.config/nvim/lua/setup/* source <afile> | PackerCompile
augroup end

