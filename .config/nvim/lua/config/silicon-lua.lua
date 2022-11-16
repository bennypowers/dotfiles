require'silicon'.setup {
  windowControls = false,
  output = string.format(
    vim.fn.expand"~/Pictures/Screenshots/SILICON_%s-%s-%s_%s-%s.png",
    os.date("%Y"),
    os.date("%m"),
    os.date("%d"),
    os.date("%H"),
    os.date("%M")
 ),
}

local silicon_utils = require'silicon.utils'

vim.api.nvim_create_augroup('SiliconRefresh', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = 'SiliconRefresh',
	desc = 'Reload silicon themes cache on colorscheme switch',
	callback = function()
		silicon_utils.build_tmTheme()
		silicon_utils.reload_silicon_cache({async = true})
	end,
})
