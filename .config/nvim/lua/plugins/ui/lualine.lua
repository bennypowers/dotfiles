-- pretty statusline
return { 'nvim-lualine/lualine.nvim',
  config = function()
    local theme = ( vim.g.colors_name == 'tokyonight' and 'tokyonight'
        or vim.g.colors_name == 'catppuccin' and 'catppuccin'
        or 'auto' )

    local colors = require 'catppuccin.palettes'.get_palette()

    local MODES = {
      BUFFERS = colors.teal,
      ['c']  = {'COMMAND-LINE',      colors.red},
      ['ce'] = {'NORMAL EX',         colors.red},
      ['cv'] = {'EX',                colors.red},
      ['i']  = {'INSERT',            colors.green},
      ['ic'] = {'INS-COMPLETE',      colors.green},
      ['n']  = {'NORMAL',            colors.blue},
      ['no'] = {'OPERATOR-PENDING',  colors.purple},
      ['r']  = {'HIT-ENTER',         colors.sky},
      ['r?'] = {':CONFIRM',          colors.sky},
      ['rm'] = {'--MORE',            colors.blue},
      ['R']  = {'REPLACE',           colors.pink},
      ['Rv'] = {'VIRTUAL',           colors.mauve},
      ['s']  = {'SELECT',            colors.sapphire},
      ['S']  = {'SELECT',            colors.sapphire},
      ['␓']  = {'SELECT',            colors.sapphire},
      ['t']  = {'TERMINAL',          colors.peach},
      ['v']  = {'VISUAL',            colors.mauve},
      ['V']  = {'VISUAL LINE',       colors.mauve},
      ['␖']  = {'VISUAL BLOCK',      colors.mauve},
      ['!']  = {'SHELL',             colors.yellow},
    }

    require 'lualine'.setup {
      theme = theme,
      extentions = {},
      options = {
        disabled_filetypes = { 'neo-tree' },
        globalstatus = true,
      },
      sections = {
        lualine_a = { {
          function()
            return vim.g.libmodalActiveModeName or MODES[vim.api.nvim_get_mode().mode][1]
          end,
          color = function(section)
            return { gui = 'bold', fg = colors.crust, bg = MODES[vim.g.libmodalActiveModeName] or MODES[vim.api.nvim_get_mode().mode][2] }
          end,
        } },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    }
  end
}

