return function ()
    local wk = require'which-key'

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

    wk.setup {
        plugins = {
            spelling = {
                enabled = true,
            },
        },
    }

    local can_legendary, legendary = pcall(require, 'legendary')
    if can_legendary then
        legendary.setup {
            include_builtin = true,
            auto_register_which_key = true,
            select_prompt = 'Command Pallete'
        }
    end

    -- <space>
    wk.register({

        b = {
            name = "buffers",
            j = 'next buffer',
            k = 'previous buffer',
            p = 'pick buffer',
            d = 'delete buffer',
        },

        D = 'goto type definition',
        R = 'rename refactor',
        e = 'open diagnostics in floating window',

        s = 'save file',
        q = 'quit',

        ['}'] = 'next buffer',
        ['{'] = 'previous buffer',

        t = {
            name = 'terminals',
            t = { function() BuiltinTerminalWrapper:open() end, 'open shell' },
            f = { term_with_command, 'open terminal with command' },
            s = { scratch_with_command, 'scratch terminal with command' },
        },

        w = 'close buffer',

        ['\\'] = 'toggle file tree (float)',
        ['|'] = {'<cmd>NeoTreeRevealToggle<CR>', 'toggle file tree (sidebar)'},

        p = 'find files',
        F = 'find in files (live grep)',

        ['.'] = 'code actions',

        k = 'command pallete',

        c = {
            name = 'colours',
            c = 'cycle colour format',
            h = 'format as hsl()',
        },

        l = {
            name = 'lsp',
            f = 'format file',
            r = 'rename',
            k = 'signature_help',
            d = 'goto declaration',
            D = 'goto type definition',
            e = 'open diagnostics in floating window',
        },

        f = {
            name = 'find',
            f = 'format file',
            g = 'find in files (live grep)',
            b = 'find buffers',
            h = 'find in help',
            s = 'find symbol',
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

         D = 'goto declaration',
         d = 'goto definitions',
         i = 'goto implementations',
         r = 'goto references',
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

end

