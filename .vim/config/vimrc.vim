let mapleader = " "

" source ~/.vim/config/nerdtree.vim
" source ~/.vim/config/compe.vim

source ~/.vim/config/plugins.vim
source ~/.vim/config/telescope.vim
source ~/.vim/config/background.vim
source ~/.vim/config/tree.vim
source ~/.vim/config/tabline.vim
source ~/.vim/config/airline.vim
source ~/.vim/config/lsp.vim
source ~/.vim/config/vgit.vim
source ~/.vim/config/cmp.vim
source ~/.vim/config/trouble.vim
source ~/.vim/config/keybindings.vim

if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
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
:set wrap
:set linebreak
:set nolist
:set mouse=a

" let g:nord_underline_option = 'none'
" let g:nord_italic = v:true
" let g:nord_italic_comments = v:false
" let g:nord_minimal_mode = v:false
" colorscheme nordbuddy

" let g:pinkmare_transparent_background=1
" colorscheme pinkmare

"colorscheme omni

lua << EOF
local nightfox = require('nightfox')

-- This function set the configuration of nightfox. If a value is not passed in the setup function
-- it will be taken from the default configuration above
nightfox.setup({
  fox = "duskfox", -- change the colorscheme to use nordfox
  styles = {
    comments = "italic", -- change style of comments to be italic
    keywords = "bold", -- change style of keywords to be bold
    functions = "italic,bold" -- styles can be a comma separated list
  },
  inverse = {
    match_paren = true, -- inverse the highlighting of match_parens
  },
  colors = {
    bg = "#111111",
  },
  hlgroups = {
    TSPunctDelimiter = { fg = "${red}" }, -- Override a highlight group with the color red
    LspCodeLens = { bg = "#000000", style = "italic" },
  }
})

-- Load the configuration set above and apply the colorscheme
nightfox.load()
EOF

filetype off
filetype plugin indent on

if &shell =~# 'fish$'
	set shell=sh
endif

" Markdown fenced code blocks
let g:vim_markdown_fenced_languages = [
      \ 'css', 'scss', 'html',
      \ 'python', 'py=python',
      \ 'sh', 'bash=sh',
      \ 'fish',
      \ 'typescript', 'ts=typescript', 'javascript', 'js=javascript', 'json=javascript',
      \ 'graphql', 'gql=graphql',
      \ 'vim']

" Auto-close tags
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.md,*.ts,*.js'
let g:closetag_filetypes = 'html,xhtml,phtml,md,js,ts'

highlight Comment cterm=italic
