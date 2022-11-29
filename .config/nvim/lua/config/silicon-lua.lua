require'silicon'.setup {
  windowControls = false,
  gobble = true,
  padHoriz = 30,
  padVert = 20,
  shadowBlurRadius = 5,
  bgColor = '#3330';
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

ag('SiliconRefresh', { clear = true })
au('ColorScheme', {
  group = 'SiliconRefresh',
	desc = 'Reload silicon themes cache on colorscheme switch',
	callback = function()
		silicon_utils.build_tmTheme()
    silicon_utils.reload_silicon_cache({
      async = true,
    })
	end,
})
