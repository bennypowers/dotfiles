-- bootstrap plugins
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath }
end

-- disable some built-in plugins
vim.g.loaded_netrw       = 1
vim.g.loaded_matchparen  = 1
vim.g.loaded_netrwPlugin = 1

vim.g.termguicolors      = true
vim.g.mapleader          = ' '
vim.env.BASH_ENV         = '~/.config/bashrc'

vim.opt.rtp:prepend(lazypath)
vim.opt.rtp:prepend '/usr/local/share/gnvim/runtime/'
vim.opt.backspace      = 'indent,eol,start'
vim.opt.cmdheight      = 0
vim.opt.colorcolumn    = '100'
vim.opt.cursorcolumn   = true
vim.opt.cursorline     = true
vim.opt.encoding       = 'UTF-8'
vim.opt.laststatus     = 3

vim.opt.linebreak      = true
vim.opt.list           = true

vim.opt.completeopt    = 'menu,menuone,noselect'

vim.opt.mouse          = 'a'
vim.opt.mousemoveevent = true

vim.opt.number         = true
vim.opt.relativenumber = true

vim.opt.shell          = 'bash'
vim.opt.showtabline    = 0
vim.opt.spell          = true

vim.opt.expandtab      = true
vim.opt.tabstop        = 2
vim.opt.softtabstop    = 2
vim.opt.shiftwidth     = 2

vim.opt.virtualedit    = 'block,onemore'
vim.opt.wrap           = false

vim.opt.sessionoptions:append 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'

vim.opt.shortmess:append 'I' -- no welcome message
vim.opt.shortmess:append 'a' -- abbreviate built-in messages

vim.filetype.add {
  extension = {
    njk = 'html',
    sketchpalette = 'json',
    container = 'systemd',
    volume = 'systemd',
    network = 'systemd',
    service = 'systemd',
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
    }
  }
}

vim.lsp.handlers['window/showMessage'] = function(_, result)
  vim.notify(vim.inspect(result), ({
    vim.log.levels.ERROR,
    vim.log.levels.WARN,
    vim.log.levels.INFO,
    vim.log.levels.DEBUG,
    vim.log.levels.TRACE
  })[result.type])
end

vim.lsp.enable {
  'bashls',
  'cssls',
  'cem',
  'emmet_language_server',
  'eslint',
  'fish_lsp',
  'html',
  'gopls',
  'jsonls',
  'qmlls',
  'lua_ls',
  'marksman',
  'stylelint_lsp',
  'rust_analyzer',
  'vtsls',
  'yamlls',
  'denols',
  'design_tokens_ls'
}
