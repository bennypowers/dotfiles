local actions = require'telescope.actions'
local telescope = require'telescope'
local emoji = require'telescope-emoji'

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
}

telescope.load_extension'emoji'

local function print_emoji(e)
    vim.api.nvim_put({ e.value }, "c", false, true)
end

emoji.setup{
    action = print_emoji,
}
