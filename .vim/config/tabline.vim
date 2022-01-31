" function! TabLine()
"       let s = ''
"       for i in range(tabpagenr('$'))
"             let tabnr = i + 1 " range() starts at 0
"             let winnr = tabpagewinnr(tabnr)
"             let buflist = tabpagebuflist(tabnr)
"             let bufnr = buflist[winnr - 1]
"             let bufname = fnamemodify(bufname(bufnr), ':t')

"             let s .= '%#TabLineFill# | '
"             let s .= (tabnr == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')

"             let n = '' 
"             if n > 1 | let s .= ':' . n | endif

"             let s .= empty(bufname) ? ' [No Name] ' : WebDevIconsGetFileTypeSymbol(bufname) . ' ' . bufname . ' '

"             let bufmodified = getbufvar(bufnr, "&mod")
"             if bufmodified | let s .= '+ ' | endif
"       endfor
"       let s .= '%#TabLineFill#'
"       return s
" endfunction

" set tabline=%!TabLine()
"

lua << EOF
require('tabline').setup{
    no_name = '[No Name]',    -- Name for buffers with no name
    modified_icon = '',      -- Icon for showing modified buffer
    close_icon = '',         -- Icon for closing tab with mouse
    separator = "▌",          -- Separator icon on the left side
    padding = 3,              -- Prefix and suffix space
    color_all_icons = false,  -- Color devicons in active and inactive tabs
    always_show_tabs = false, -- Always show tabline
    right_separator = false,  -- Show right separator on the last tab
    show_index = false,       -- Shows the index of tab before filename
    show_icon = true,         -- Shows the devicon
}
EOF
