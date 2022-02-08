return function ()
    local wk = require'which-key'

    wk.setup {
        plugins = {
            spelling = {
                enabled = true,
            },
        },
    }

    wk.register({

        D = 'type definition',
        R = 'rename',
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
            p = 'preview hunks (buffer)',

            b = 'blame preview (buffer)',
            f = 'diff preview (buffer)',
            h = 'history preview (buffer)',
            u = 'reset buffer',
            g = 'gutter blame preview (buffer)',

            l = 'hunks preview (project)',
            d = 'diff preview (project)',

            q = 'hunks quickfix (project)',

            x = 'toggle diff preference',
        }


    }, { prefix = '<leader>' })

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
        }

    }, { prefix = 'g' })
end
