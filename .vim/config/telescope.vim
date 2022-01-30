lua << END
local actions = require('telescope.actions')
local null_ls = require("null-ls")
local eslint = require("eslint")
local telescope = require("telescope")

telescope.setup{
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--ignore',
            '--hidden'
        },
        file_ignore_patterns = {
            ".git",
            "node_modules"
        },
        prompt_prefix = "🔎 ",
        mappings = {
            i = {
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-j>"] = actions.move_selection_next,
                ["<esc>"] = actions.close
            }
        }
    },
    pickers = {
        lsp_code_actions = {
            theme = "cursor"
        },
        lsp_workspace_diagnostics = {
            theme = "dropdown"
        }
    },
    extensions = {
        command_palette = {
            {"File",
                { "entire selection (C-a)", ':call feedkeys("GVgg")' },
                { "save current file (C-s)", ':w' },
                { "save all files (C-A-s)", ':wa' },
                { "quit (C-q)", ':qa' },
                { "file browser (C-i)", ":lua require'telescope'.extensions.file_browser.file_browser()", 1 },
                { "search word (A-w)", ":lua require('telescope.builtin').live_grep()", 1 },
                { "git files (A-f)", ":lua require('telescope.builtin').git_files()", 1 },
                { "files (C-f)",     ":lua require('telescope.builtin').find_files()", 1 },
            },
            {"Help",
                { "tips", ":help tips" },
                { "cheatsheet", ":help index" },
                { "tutorial", ":help tutor" },
                { "summary", ":help summary" },
                { "quick reference", ":help quickref" },
                { "search help(F1)", ":lua require('telescope.builtin').help_tags()", 1 },
            },
            {"Vim",
                { "reload vimrc", ":source $MYVIMRC" },
                { 'check health', ":checkhealth" },
                { "jumps (Alt-j)", ":lua require('telescope.builtin').jumplist()" },
                { "commands", ":lua require('telescope.builtin').commands()" },
                { "command history", ":lua require('telescope.builtin').command_history()" },
                { "registers (A-e)", ":lua require('telescope.builtin').registers()" },
                { "colorshceme", ":lua require('telescope.builtin').colorscheme()", 1 },
                { "vim options", ":lua require('telescope.builtin').vim_options()" },
                { "keymaps", ":lua require('telescope.builtin').keymaps()" },
                { "buffers", ":Telescope buffers" },
                { "search history (C-h)", ":lua require('telescope.builtin').search_history()" },
                { "paste mode", ':set paste!' },
                { 'cursor line', ':set cursorline!' },
                { 'cursor column', ':set cursorcolumn!' },
                { "spell checker", ':set spell!' },
                { "relative number", ':set relativenumber!' },
                { "search highlighting (F12)", ':set hlsearch!' },
            },
            {"LSP",
                { "Format File", ":lua vim.lsp.buf.formatting()" },
            },
        }
    }
}

telescope.load_extension('command_palette')
null_ls.setup()

eslint.setup({
  bin = 'eslint_d', -- or `eslint_d`
  code_actions = {
    enable = true,
    apply_on_save = {
      enable = true,
      types = { "problem" }, -- "directive", "problem", "suggestion", "layout"
    },
    disable_rule_comment = {
      enable = true,
      location = "separate_line", -- or `same_line`
    },
  },
  diagnostics = {
    enable = true,
    report_unused_disable_directives = false,
    run_on = "type", -- or `save`
  },
})

END


"
"             _
"           /(_))
"         _/   /
"        //   /
"       //   /
"       /\__/
"       \O_/=-.
"   _  / || \  ^o
"   \\/ ()_) \.
"    ^^ <__> \()
"      //||\\
"     //_||_\\  ds
"    // \||/ \\
"   //   ||   \\
"  \/    |/    \/
"  /     |      \
" /      |       \
"        |
"
" nnoremap <C-F> <cmd>Telescope live_grep<CR>
" God damn tmux taking the C-B bind
" nnoremap <C-L> <cmd>Telescope buffers<CR>
" nnoremap <C-N> <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<CR>

nnoremap <Leader>ff   <cmd>Telescope find_files<CR>
nnoremap <Leader>p   <cmd>Telescope find_files<CR>
nnoremap <Leader>fg   <cmd>Telescope live_grep<CR>
nnoremap <Leader>fb   <cmd>Telescope buffers<CR>
nnoremap <Leader>fh   <cmd>Telescope help_tags<CR>
nnoremap <Leader>gs   <cmd>Telescope git_status<CR>
nnoremap <silent>gr   <cmd>Telescope lsp_references<CR>
nnoremap <Leader>.    <cmd>Telescope lsp_code_actions<CR>
nnoremap <Leader>sd   <cmd>Telescope lsp_workspace_diagnostics<CR>
nnoremap <Leader>k    <cmd>Telescope command_palette<CR>

" Telly colors not really working for me
highlight TelescopeSelection guifg=#FF38A2 gui=bold
highlight TelescopeMatching guifg=#d9bcef

