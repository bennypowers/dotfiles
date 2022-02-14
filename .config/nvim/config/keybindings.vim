let mapleader = " "

" Integrated Terminal
"
nmap <c-t> :term<cr>

" LSP
"
nnoremap gD                   <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap K                    <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <C-k>                <cmd>lua vim.lsp.buf.signature_help()<CR>

nnoremap <leader>lf           <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <leader>lr           <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>lk           <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>ld           <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <leader>le           <cmd>lua vim.diagnostic.open_float({ focus = false })<CR>

nnoremap <leader>D            <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <leader>R            <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>e            <cmd>lua vim.diagnostic.open_float({ focus = false })<CR>

nnoremap <silent><M-,>        <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent><M-.>        <cmd>lua vim.diagnostic.goto_next()<CR>

" nnoremap <leader>q            <cmd>lua vim.diagnostic.setloclist()<CR>

" Colors
nnoremap <leader>cc :lua require'color-converter'.cycle()<CR>
nnoremap <leader>ch :lua require'color-converter'.to_hsl()<CR>:s/%//g<CR>

" Tabs
"
nnoremap <C-i>     :source ~/.config/nvim/init.vim<CR>
nnoremap <leader>s :w<CR>

" bufferline.nvim bindings
"
nnoremap <leader>t :BufferLinePick<CR>
nnoremap <leader>} :BufferLineCycleNext<CR>
nnoremap <leader>{ :BufferLineCyclePrev<CR>
nnoremap <leader>w :Bdelete<CR>
nnoremap <leader>q :qa<CR>

" Tree
"
nnoremap <leader>\ :NeoTreeFocusToggle<cr>

" Edge motion
"
" Jump to the next or previous line that has the same level or a lower
" level of indentation than the current line.
"
" exclusive (bool): true: Motion is exclusive
" false: Motion is inclusive
" fwd (bool): true: Go to next line
" false: Go to previous line
" lowerlevel (bool): true: Go to line with lower indentation level
" false: Go to line with the same indentation level
" skipblanks (bool): true: Skip blank lines
" false: Don't skip blank lines
function! NextIndent(exclusive, fwd, lowerlevel, skipblanks)
  let line = line('.')
  let column = col('.')
  let lastline = line('$')
  let indent = indent(line)
  let stepvalue = a:fwd ? 1 : -1
  while (line > 0 && line <= lastline)
    let line = line + stepvalue
    if ( ! a:lowerlevel && indent(line) == indent ||
          \ a:lowerlevel && indent(line) < indent)
      if (! a:skipblanks || strlen(getline(line)) > 0)
        if (a:exclusive)
          let line = line - stepvalue
        endif
        exe line
        exe "normal " column . "|"
        return
      endif
    endif
  endwhile
endfunction

" Moving back and forth between lines of same or lower indentation.
nnoremap <silent><M-]>  :call NextIndent(0, 0, 0, 1)<CR>
nnoremap <silent><M-[>  :call NextIndent(0, 1, 0, 1)<CR>
vnoremap <silent> [h    <Esc>:call NextIndent(0, 0, 0, 1)<CR>m'gv''
vnoremap <silent> ]j    <Esc>:call NextIndent(0, 1, 0, 1)<CR>m'gv''
vnoremap <silent> [h    <Esc>:call NextIndent(0, 0, 1, 1)<CR>m'gv''
vnoremap <silent> ]j    <Esc>:call NextIndent(0, 1, 1, 1)<CR>m'gv''
onoremap <silent> [h    :call NextIndent(0, 0, 0, 1)<CR>
onoremap <silent> ]j    :call NextIndent(0, 1, 0, 1)<CR>
onoremap <silent> [h    :call NextIndent(1, 0, 1, 1)<CR>
onoremap <silent> ]j    :call NextIndent(1, 1, 1, 1)<CR>

" Telescope
"
" nnoremap : <cmd>FineCmdline<CR>
nnoremap <leader>p          <cmd>Telescope find_files hidden=true<CR>
nnoremap <leader>F          <cmd>Telescope live_grep<CR>

nnoremap <leader>fg         <cmd>Telescope live_grep<CR>
nnoremap <leader>fb         <cmd>Telescope buffers<CR>
nnoremap <leader>fh         <cmd>Telescope help_tags<CR>
nnoremap <leader>fs         <cmd>Telescope symbols<CR>

nnoremap <leader>.          <cmd>Telescope lsp_code_actions<CR>

nnoremap <silent>gd         <cmd>Telescope lsp_definitions<CR>
nnoremap <silent>gi         <cmd>Telescope lsp_implementations<CR>
nnoremap <silent>gr         <cmd>Telescope lsp_references<CR>

nnoremap <leader>k          :Legendary<cr>

imap <A-M-Space>            <cmd>Telescope symbols<CR>

" Multiple Cursors
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-d>'           " replace C-n
let g:VM_maps['Find Subword Under'] = '<C-d>'           " replace visual C-n

" Snippets
"
imap <expr> <Tab>           snippy#can_expand_or_advance()  ? '<Plug>(snippy-expand-or-advance)'  : '<Tab>'
imap <expr> <S-Tab>         snippy#can_jump(-1)             ? '<Plug>(snippy-previous)'           : '<S-Tab>'
smap <expr> <Tab>           snippy#can_jump(1)              ? '<Plug>(snippy-next)'               : '<Tab>'
smap <expr> <S-Tab>         snippy#can_jump(-1)             ? '<Plug>(snippy-previous)'           : '<S-Tab>'
xmap <Tab>                  <Plug>(snippy-cut-text)

