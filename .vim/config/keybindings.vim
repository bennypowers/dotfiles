" LSP
"
nnoremap gD          <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap K           <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <C-k>       <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <space>wa   <cmd>lua vim.lsp.buf.add_workspace_folder()<CR>
nnoremap <space>wr   <cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>
nnoremap <space>wl   <cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>
nnoremap <space>D    <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <space>rn   <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <space>e    <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap [d          <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap ]d          <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <space>q    <cmd>lua vim.diagnostic.setloclist()<CR>
nnoremap <space>f    <cmd>lua vim.lsp.buf.formatting()<CR>

" Tabs
"
nnoremap <C-i> :source ~/.vimrc<CR>
nnoremap <leader>t :tabnew<CR>
nnoremap <leader>} :tabnext<CR>
nnoremap <leader>{ :tabprevious<CR>
nnoremap <leader>s :w<CR>

" Telescope
"
nnoremap <Leader>ff         <cmd>Telescope find_files<CR>
nnoremap <Leader>p          <cmd>Telescope find_files<CR>
nnoremap <Leader>fg         <cmd>Telescope live_grep<CR>
nnoremap <Leader><S-f>      <cmd>Telescope live_grep<CR>
nnoremap <Leader>fb         <cmd>Telescope buffers<CR>
nnoremap <Leader>fh         <cmd>Telescope help_tags<CR>
nnoremap <Leader>gs         <cmd>Telescope git_status<CR>
nnoremap <silent>gr         <cmd>Telescope lsp_references<CR>
nnoremap <Leader>.          <cmd>Telescope lsp_code_actions<CR>
nnoremap <Leader>sd         <cmd>Telescope lsp_workspace_diagnostics<CR>
nnoremap <silent>gd         <cmd>Telescope lsp_definitions<CR>
nnoremap <silent>gi         <cmd>Telescope lsp_implementations<CR>
nnoremap <Leader>k          :lua require'telescope.builtin'.commands(require('telescope.themes').get_dropdown({}))<cr>
