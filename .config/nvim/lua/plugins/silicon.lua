local function screenshot()
  require'silicon'.visualise_api { }
end

local function screenshot_buffer()
  require'silicon'.visualise_api { show_buf = true }
end

local function screenshot_debug()
  require'silicon'.visualise_api { debug = true }
end

local function screenshot_visible()
  require'silicon'.visualise_api { visible  = true }
end

-- Take screenshots from nvim
return { 'narutoxy/silicon.lua',
  enabled = false,
  lazy = true,
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>ss', screenshot,         mode = 'n', desc = 'Save a Screenshot' },
    { '<leader>sb', screenshot_buffer,  mode = 'n', desc = 'Save a Screenshot with Buffer' },
    { 'ss',         screenshot,         mode = 'v', desc = 'Save a Screenshot' },
    { 'sv',         screenshot_visible, mode = 'v', desc = 'Save a Screenshot of visible area' },
    { 'sb',         screenshot_buffer,  mode = 'v', desc = 'Save a Screenshot of entire Buffer' },
  },
  config = function()
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
  end
}

