-- disable some built-in plugins
vim.g.loaded_netrw = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrwPlugin = 1

vim.g.termguicolors = true
vim.g.mapleader = ' '
vim.env.BASH_ENV = '~/.config/bashrc'

vim.opt.rtp:prepend '/usr/local/share/gnvim/runtime/'
vim.opt.backspace = 'indent,eol,start'
vim.opt.cmdheight = 0
vim.opt.colorcolumn = '100'
vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.encoding = 'UTF-8'
vim.opt.laststatus = 3

vim.opt.linebreak = true
vim.opt.list = true

vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }
vim.opt.winborder = 'rounded'

vim.opt.mouse = 'a'
vim.opt.mousemoveevent = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.shell = 'bash'
vim.opt.showtabline = 0
vim.opt.spell = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.virtualedit = 'block,onemore'
vim.opt.wrap = false

vim.opt.sessionoptions:append 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'

vim.opt.shortmess:append 'I' -- no welcome message
vim.opt.shortmess:append 'a' -- abbreviate built-in messages

require 'vim._core.ui2'.enable {
  enable = true,
  msg = {
    targets = 'msg',
    msg = {
      timeout = 4000,
    },
  },
}

vim.filetype.add {
  extension = {
    hbs           = 'handlebars',
    handlebars    = 'handlebars',
    mustache      = 'handlebars',
    j2            = 'jinja',
    twig          = 'jinja',
    jinja         = 'jinja',
    jinja2        = 'jinja',
    njk           = 'jinja',
    webc          = 'html',
    sketchpalette = 'json',
    container     = 'systemd',
    volume        = 'systemd',
    network       = 'systemd',
    service       = 'systemd',
  },
}

vim.diagnostic.config {
  virtual_lines = {
    current_line = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '\u{ea87}',
      [vim.diagnostic.severity.WARN] = '\u{ea6c}',
      [vim.diagnostic.severity.INFO] = '\u{ea74}',
      [vim.diagnostic.severity.HINT] = '💭',
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticErrorLine',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarningLine',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarning',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInformation',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
    },
  },
}
