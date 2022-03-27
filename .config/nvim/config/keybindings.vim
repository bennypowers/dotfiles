let mapleader = " "

" Window management
"
nnoremap ; <C-w>

" Tabs
"
nnoremap <C-i>     :source ~/.config/nvim/init.vim<CR>

" Splits
nnoremap <leader>; :vnew<CR>

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

