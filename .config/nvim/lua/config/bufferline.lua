local bufferline = require'bufferline'
vim.cmd 'source ~/.config/nvim/config/bbye.vim'

-- local palette = require'nightfox.palette'.load'duskfox'
-- local nightfox_highlights = {
--     fill =                           {                              guibg = palette.bg1 },
--     background =                     {                              guibg = palette.bg1 },
--     close_button =                   { guifg = palette.red.base,    guibg = palette.bg1 },
--     close_button_selected =          { guifg = palette.red.base,    guibg = palette.bg1 },
--     close_button_visible =           { guifg = palette.red.base,    guibg = palette.bg1 },
--     tab_close =                      { guifg = palette.red.base,    guibg = palette.bg1 },
--     -- tab =                         { guifg = '<c>', guibg = '<c>' },
--     -- tab_selected =                { guifg = tabline_sel_bg, guibg = '<c>' },
--
--     separator =                      { guifg = palette.cyan.bright, guibg = palette.bg1 },
--     separator_visible =              { guifg = palette.cyan.bright, guibg = palette.bg1 },
--     separator_selected =             { guifg = palette.cyan.bright, guibg = palette.bg1 },
--
--     error =                          { guifg = palette.red.base,    guibg = palette.bg1 },
--     -- error =                       { guifg = '<c>', guibg = '<c>', guisp = '<c>' },
--     -- error_visible =               { guifg = '<c>', guibg = '<c>' },
--     -- error_selected =              { guifg = '<c>', guibg = '<c>', gui = "bold,italic", guisp = '<c>' },
--     -- error_diagnostic =            { guifg = '<c>', guibg = '<c>', guisp = '<c>' },
--     -- error_diagnostic_visible =    { guifg = '<c>', guibg = '<c>' },
--     -- error_diagnostic_selected =   { guifg = '<c>', guibg = '<c>', gui = "bold,italic", guisp = '<c>' },
--
--     warning =                        { guifg = palette.orange.base, guibg = palette.bg1 },
--     -- warning_visible =             { guifg = '<c>', guibg = '<c>' },
--     -- warning_selected =            { guifg = '<c>', guibg = '<c>', gui = "bold,italic", guisp = '<c>' },
--     -- warning_diagnostic =          { guifg = '<c>', guisp = '<c>', guibg = '<c>' },
--     -- warning_diagnostic_visible =  { guifg = '<c>', guibg = '<c>' },
--     -- warning_diagnostic_selected = { guifg = '<c>', guibg = '<c>', gui = "bold,italic", guisp = warning_diagnostic_fg },
--
--     info =                           { guifg = palette.blue.base,   guibg = palette.bg1 },
--     -- info_visible =                { guifg = '<c>', guibg = '<c>' },
--     -- info_selected =               { guifg = '<c>', guibg = '<c>', gui = "bold,italic", guisp = '<c>' },
--     -- info_diagnostic =             { guifg = '<c>', guisp = '<c>', guibg = '<c>' },
--     -- info_diagnostic_visible =     { guifg = '<c>', guibg = '<c>' },
--     -- info_diagnostic_selected =    { guifg = '<c>', guibg = '<c>', gui = "bold,italic", guisp = '<c>' },
--
--     -- buffer_visible =              { guifg = '<c>', guibg = '<c>' },
--     -- buffer_selected =             { guifg = normal_fg, guibg = '<c>', gui = "bold,italic" },
--
--     -- diagnostic =                  { guifg = '<c>', guibg = '<c>', },
--     -- diagnostic_visible =          { guifg = '<c>', guibg = '<c>', },
--     -- diagnostic_selected =         { guifg = '<c>', guibg = '<c>', gui = "bold,italic" },
--
--     -- modified =                    { guifg = '<c>', guibg = '<c>' },
--     -- modified_visible =            { guifg = '<c>', guibg = '<c>' },
--     -- modified_selected =           { guifg = '<c>', guibg = '<c>' },
--
--     -- duplicate_selected =          { guifg = '<c>', gui = "italic", guibg = '<c>' },
--     -- duplicate_visible =           { guifg = '<c>', gui = "italic", guibg = '<c>' },
--     -- duplicate =                   { guifg = '<c>', gui = "italic", guibg = '<c>' },
--
--     -- indicator_selected =          { guifg = '<c>', guibg = '<c>' },
--
--     -- pick_selected =               { guifg = '<c>', guibg = '<c>', gui = "bold,italic" },
--     -- pick_visible =                { guifg = '<c>', guibg = '<c>', gui = "bold,italic" },
--     -- pick =                        { guifg = '<c>', guibg = '<c>', gui = "bold,italic" }
--   }

bufferline.setup {

  --highlights = nightfox_highlights,
  options = {
    numbers = 'none',
    diagnostics = 'nvim_lsp',
    show_buffer_icons = true,
    show_close_icon = true,
    custom_filter = function(bufnr)
      local filetype = vim.bo[bufnr].filetype
      local filename = vim.fn.bufname(bufnr)
      return (
            filetype ~= 'neo-tree'
        and filetype ~= 'Trouble'
        and filename ~= 'neo-tree filesystem [1]'
        and filename ~= '[No Name]'
      )
    end,
    offsets = {
      {
        filetype = "neo-tree",
        text_align = "center",
        highlight = 'Directory',
        text = 'Files',
      },
    },
  },

}
