let mapleader = " "

source ~/.vim/config/plugins.vim
source ~/.vim/config/telescope.vim
source ~/.vim/config/background.vim
source ~/.vim/config/nerdtree.vim
source ~/.vim/config/tabline.vim
source ~/.vim/config/airline.vim
source ~/.vim/config/lsp.vim
source ~/.vim/config/vgit.vim
source ~/.vim/config/compe.vim


syntax on
set nocompatible
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
set guifont=Fira\ Code:h14
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

let g:pinkmare_transparent_background=1
colorscheme pinkmare

filetype off
filetype plugin indent on

if &shell =~# 'fish$'
	set shell=sh
endif

nnoremap <C-i> :source ~/.vimrc<CR>
nnoremap <leader>} :tabnext<CR>
nnoremap <leader>{ :tabprevious<CR>
nnoremap <leader>s :w<CR>

" Markdown fenced code blocks
let g:markdown_fenced_languages = [
      \ 'css', 'scss', 'html',
      \ 'python',
      \ 'bash=sh',
      \ 'typescript', 'ts=typescript', 'javascript', 'js=javascript', 'json=javascript',
      \ 'graphql', 'gql=graphql',
      \ 'vim']

" Auto-close tags
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.md'
let g:closetag_filetypes = 'html,xhtml,phtml,md'

