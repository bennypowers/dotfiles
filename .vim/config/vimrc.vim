let mapleader = " "

if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

if &shell =~# 'fish$'
	set shell=sh
endif

syntax on
set nocompatible
set completeopt=menu,menuone,noselect
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
set virtualedit=all
set cursorline
set cursorcolumn
:set wrap
:set linebreak
:set nolist
:set mouse=a

filetype off
filetype plugin indent on

highlight Comment cterm=italic

" adding to vim-airline's tabline
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1
let g:airline_powerline_fonts=1

" Auto-close tags
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.md,*.ts,*.js'
let g:closetag_filetypes = 'html,xhtml,phtml,md,js,ts'

" Markdown fenced code blocks
let g:vim_markdown_fenced_languages = [
      \ 'css', 'scss', 'html',
      \ 'python', 'py=python',
      \ 'sh', 'bash=sh',
      \ 'fish',
      \ 'typescript', 'ts=typescript', 'javascript', 'js=javascript', 'json=javascript',
      \ 'graphql', 'gql=graphql',
      \ 'vim']

source ~/.vim/config/keybindings.vim
source ~/.vim/config/background.vim
source ~/.vim/config/plugins.vim

source ~/.vim/config/tabline.lua
source ~/.vim/config/trouble.lua
source ~/.vim/config/telescope.lua
source ~/.vim/config/lsp.lua
source ~/.vim/config/cmp.lua
source ~/.vim/config/tree.lua
source ~/.vim/config/vgit.lua
source ~/.vim/config/nightfox.lua

