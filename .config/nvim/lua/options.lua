-- disable some built-in plugins
vim.g.loaded_netrw           = 1
vim.g.loaded_matchparen      = 1
vim.g.loaded_netrwPlugin     = 1
vim.g.Illuminate_ftblacklist = { 'neo-tree' }

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
vim.opt.mousemoveevent = true
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.pastetoggle    = '<F10>'
vim.opt.shiftwidth     = 2
vim.opt.softtabstop    = 2
vim.opt.tabstop        = 2
vim.opt.termguicolors  = true
vim.opt.virtualedit    = 'block,onemore'
vim.opt.wrap           = false
vim.opt.shell          = 'bash'
vim.opt.cmdheight      = 0
vim.opt.list           = true
vim.opt.spell          = true
-- vim.opt.foldlevel      = 20

vim.opt.sessionoptions:append'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'

vim.opt.shortmess:append'I' -- no welcome message
vim.opt.shortmess:append'a' -- abbreviate built-in messages

vim.filetype.add { extension = {
  njk = 'html',
  sketchpalette = 'json',
} }

if vim.g.started_by_firenvim then
  vim.g.auto_session_enabled = false
  vim.opt.laststatus = 0
  vim.opt.showtabline = 0
  vim.opt.guifont = 'FiraCode_Nerd_Font'
  au('BufEnter', {
    group = ag('firenvim_md', {}),
    pattern = 'github.com_*.txt',
    command = 'set filetype=markdown'
  })
end

