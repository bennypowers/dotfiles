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
set foldexpr="nvim_treesitter#foldexpr()"

filetype off
filetype plugin indent on

highlight Comment cterm=italic

" adding to vim-airline's tabline
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1
let g:airline_powerline_fonts=1

" Auto-close tags
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.md,*.ts,*.js,*.njk'
let g:closetag_filetypes = 'html,xhtml,phtml,md,js,ts,njk,jinja'

" Markdown fenced code blocks
let g:vim_markdown_fenced_languages = [
      \ 'css', 'scss', 'html',
      \ 'python', 'py=python',
      \ 'sh', 'bash=sh',
      \ 'fish',
      \ 'typescript', 'ts=typescript', 'javascript', 'js=javascript', 'json=javascript',
      \ 'graphql', 'gql=graphql',
      \ 'vim']

au BufNewFile,BufRead *.njk set ft=jinja

source ~/.config/nvim/config/background.vim
source ~/.config/nvim/config/plugins.vim
source ~/.config/nvim/config/tree-settings.vim

call wilder#setup({'modes': [':', '/', '?']})

source ~/.config/nvim/config/barbar.lua
source ~/.config/nvim/config/trouble.lua
source ~/.config/nvim/config/telescope.lua
source ~/.config/nvim/config/lsp.lua
source ~/.config/nvim/config/cmp.lua
source ~/.config/nvim/config/tree.lua
source ~/.config/nvim/config/vgit.lua
source ~/.config/nvim/config/nightfox.lua
source ~/.config/nvim/config/treesitter.lua

source ~/.config/nvim/config/keybindings.vim

" Hide cmdline
" set noshowmode
" set noshowcmd
" set shortmess+=F
" set laststatus=0 " For some reason this doesnt work
" autocmd BufRead,BufNewFile * set laststatus=0 " This will work instead

