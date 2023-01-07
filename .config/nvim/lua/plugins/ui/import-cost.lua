return { 'barrett-ruth/import-cost.nvim', lazy = true, build = 'sh install.sh npm', config = function ()

require'import-cost'.setup()

end }


