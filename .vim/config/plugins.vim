" Get Plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
"--- Themes
Plug 'matsuuu/pinkmare'
Plug 'ryanoasis/vim-devicons'
Plug 'maaslalani/nordbuddy'
Plug 'EdenEast/nightfox.nvim'
Plug 'tjdevries/colorbuddy.vim'
Plug 'bkegley/gloombuddy'
Plug 'yonlu/omni.vim'

"--- Tellyscope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

"--- Syntax
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/playground'
Plug 'sheerun/vim-polyglot'
Plug 'dag/vim-fish'

"--- Functional
" Plug 'scrooloose/nerdtree'
" Plug 'scrooloose/nerdtree-project-plugin'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plug 'PhilRunninger/nerdtree-visual-selection'
" Plug 'PhilRunninger/nerdtree-buffer-ops'
" Plug 'jistr/vim-nerdtree-tabs'
" Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'seblj/nvim-tabline'

"--- Sessions
Plug 'tpope/vim-obsession'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"--- Editing
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'mattn/emmet-vim'
Plug 'pechorin/any-jump.vim'

"--- LSP
Plug 'neovim/nvim-lspconfig'
" Plug 'hrsh7th/nvim-compe'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'onsails/lspkind-nvim'
Plug 'mfussenegger/nvim-jdtls'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'MunifTanjim/eslint.nvim'
Plug 'folke/lsp-trouble.nvim'

"--- Completions
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
"-- Snippets
Plug 'dcampos/nvim-snippy'
Plug 'dcampos/cmp-snippy'

"--- Git
Plug 'tanvirtin/vgit.nvim'

"--- Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }

"--- Webdev
Plug 'jonsmithers/vim-html-template-literals'
Plug 'ap/vim-css-color'
Plug 'sbdchd/neoformat'

call plug#end()

