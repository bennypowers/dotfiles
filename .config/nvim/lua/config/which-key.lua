return function ()
    local wk = require'which-key'

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

        D = 'goto type definition',
        R = 'rename refactor',
        e = 'open diagnostics in floating window',

        s = 'save file',
        q = 'quit',

        ['}'] = 'next buffer',
        ['{'] = 'previous buffer',

        t = 'choose buffer',
        w = 'close buffer',

        ['\\'] = 'toggle file tree',

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

