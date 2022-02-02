" LSP
"
nnoremap gD          <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap K           <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <C-k>       <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>wa   <cmd>lua vim.lsp.buf.add_workspace_folder()<CR>
nnoremap <leader>wr   <cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>
nnoremap <leader>wl   <cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>
nnoremap <leader>D    <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <leader>rn   <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>e    <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap [d          <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap ]d          <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <leader>q    <cmd>lua vim.diagnostic.setloclist()<CR>
nnoremap <leader>f    <cmd>lua vim.lsp.buf.formatting()<CR>

" Tabs
"
nnoremap <C-i> :source ~/.vimrc<CR>
nnoremap <leader>t :tabnew<CR>
nnoremap <leader>} :tabnext<CR>
nnoremap <leader>{ :tabprevious<CR>
nnoremap <leader>s :w<CR>

" Telescope
"
nnoremap <leader>ff         <cmd>Telescope find_files<CR>
nnoremap <leader>p          <cmd>Telescope find_files<CR>
nnoremap <leader>fg         <cmd>Telescope live_grep<CR>
nnoremap <leader><S-f>      <cmd>Telescope live_grep<CR>
nnoremap <leader>fb         <cmd>Telescope buffers<CR>
nnoremap <leader>fh         <cmd>Telescope help_tags<CR>
nnoremap <leader>gs         <cmd>Telescope git_status<CR>
nnoremap <silent>gr         <cmd>Telescope lsp_references<CR>
nnoremap <leader>.          <cmd>Telescope lsp_code_actions<CR>
nnoremap <leader>sd         <cmd>Telescope lsp_workspace_diagnostics<CR>
nnoremap <silent>gd         <cmd>Telescope lsp_definitions<CR>
nnoremap <silent>gi         <cmd>Telescope lsp_implementations<CR>
nnoremap <leader>ge         <cmd>Telescope emoji<CR>
nnoremap <leader>k          :lua require'telescope.builtin'.commands(require('telescope.themes').get_dropdown({}))<cr>

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
xmap <Tab>  <Plug>(snippy-cut-text)
