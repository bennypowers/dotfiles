return function ()
    local function input_wrapper(fn)
        return function()
            vim.ui.input({ prompt = '$' }, fn)
         end
    end

    local scratch_with_command = input_wrapper(function(input)
        require'FTerm'.scratch({ cmd = input })
    end)

    local term_with_command = input_wrapper(function(input)
        BuiltinTerminalWrapper:open({ cmd = input })
    end)

    local can_legendary, legendary = pcall(require, 'legendary')
    if can_legendary then
        legendary.setup {
            include_builtin = true,
            auto_register_which_key = true,
            select_prompt = 'Command Pallete'
        }
    end

    local wk = require'which-key'

    wk.setup {
        plugins = {
            spelling = {
                enabled = true,
            },
        },
    }

    -- no leader
    wk.register({
        K = { vim.lsp.buf.hover, 'hover' },
        ['c-k'] = { vim.lsp.buf.signature_help, 'signature help' },
        ['M-,'] = { vim.diagnostic.goto_prev, 'previous diagnostic' },
        ['M-.'] = { vim.diagnostic.goto_next, 'next diagnostic' },
    })

    -- <space>
    wk.register({

        b = {
            name = "buffers",
            j = { ':BufferLineCycleNext<cr>', 'next buffer' },
            k = { ':BufferLineCyclePrev<cr>', 'previous buffer' },
            p = { ':BufferLinePick<cr>', 'pick buffer' },
            d = { ':Bdelete<cr>', 'delete buffer' },
            b = { ':Telescope buffers<cr>', 'search buffers' }
        },

        ['}'] = { ':BufferLineCycleNext<cr>', 'next buffer' },
        ['{'] = { ':BufferLineCyclePrev<cr>', 'previous buffer' },

        D = 'goto type definition',
        R = { vim.lsp.buf.rename, 'rename refactor' },
        e = { function() vim.diagnostic.open_float({ focus = false }) end, 'open diagnostics in floating window' },

        s = 'save file',
        q = 'quit',

        t = {
            name = 'terminals',
            t = { function() BuiltinTerminalWrapper:open() end, 'open shell' },
            f = { term_with_command, 'open terminal with command' },
            s = { scratch_with_command, 'scratch terminal with command' },
        },

        ['\\'] = { '<cmd>Neotree reveal filesystem float<cr>', 'toggle file tree (float)' },
        ['|'] =  { '<cmd>Neotree filesystem show left toggle=true<cr>', 'toggle file tree (sidebar)'},

        p = {'<cmd>Telescope find_files hidden=true<cr>', 'find files'},

        ['.'] = {'<cmd>Telescope lsp_code_actions<cr>','code actions'},

        k = 'command pallete',

        c = {
            name = 'colours',

            c = { function() require'color-converter'.cycle() end, 'cycle colour format' },
            h = { ':lua require"color-converter".to_hsl()<cr>:s/%//g<cr>', 'format as hsl()' },
        },

        l = {
            name = 'lsp',
            f = { vim.lsp.buf.formatting, 'format file' },
            r = { vim.lsp.buf.rename, 'rename' },
            k = { vim.lsp.buf.signature_help, 'signature_help' },
            d = { vim.lsp.buf.declaration, 'goto declaration' },
            D = { vim.lsp.buf.type_definition, 'goto type definition' },
            e = { function() vim.diagnostic.open_float({ focus = false }) end, 'open diagnostics in floating window' },
        },

        f = {
            name = 'find',
            g = {'<cmd>Telescope live_grep<cr>', 'find in files (live grep)'},
            b = {'<cmd>Telescope buffers<cr>', 'find buffers'},
            h = {'<cmd>Telescope help_tags<cr>', 'find in help'},
            s = {'<cmd>Telescope symbols<cr>', 'find symbol'},
            r = {'<cmd>Telescope resume<cr>', 'resume finding'},
        },

        g = {
            name = 'git',
            s = 'stage hunk',
            r = 'unstage hunk',
            p = 'preview hunks        (buffer)',

            b = 'preview blame        (buffer)',
            f = 'preview diff         (buffer)',
            h = 'preview history      (buffer)',
            u = 'reset buffer',
            g = 'preview gutter blame (buffer)',

            l = 'preview hunks        (project)',
            d = 'preview diff         (project)',

            q = 'hunks quickfix       (project)',

            x = 'toggle diff preference',
        }

    }, { prefix = '<leader>' })

    -- g
    wk.register({

        A = { ':Alpha<cr>', 'show dashboard' },

        T = { ':TroubleToggle<cr>', 'toggle trouble' },

        D = { vim.lsp.buf.declaration, 'goto declaration' },
        d = {function() require'goto-preview'.goto_preview_definition() end, 'goto definitions'},
        i = {function() require'goto-preview'.goto_preview_implementation() end, 'goto implementations'},
        r = {function() require'goto-preview'.goto_preview_references() end, 'goto references'},
        P = {function() require'goto-preview'.close_all_win() end, 'close all preview windows'},

        G = { function () --- Toggle a floating terminal with lazygit
            return require'FTerm'.scratch {
                ft = 'fterm_lazygit',
                cmd = 'lazygit',
                auto_close = true,
                }
        end , 'lazygit'},

        u = 'lowercase',
        U = 'uppercase',

        ['%'] = 'match surround backwards',

        c = {
            name = 'comments',
            c = 'comment line',
        },

        n = {
            name = 'incremental',
            n = 'select'
        },

        s = {
            name = 'caser',
            m = 'mixed case',
            p = 'mixed case',
            c = 'camelCase',
            _ = 'snake_case',
            u = 'UPPER_SNAKE',
            U = 'UPPER_SNAKE',
            t = 'Title Case',
            s = 'Sentence case',
            ['<space>'] = 'space case',
            ['-'] = 'dash-case',
            k = 'dash-case',
        },

        l = {
            name = 'align left',
        },
        L = {
            name = 'align right',
        },

    }, { prefix = 'g' })

    -- ;
    wk.register({
        w = { function() require'nvim-window'.pick() end, 'pick window' },
    }, { prefix = ';' })
end

