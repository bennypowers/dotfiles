return function()
    local Wrapper = require'consolation'.Wrapper
    local fterm = require'FTerm'
    local term = require'FTerm.terminal'

    Runner = term:new()

    FtermWrapper = Wrapper:new()

    FtermWrapper:setup {
        create = function() Runner:open() end,
        open   = function() Runner:open() end,
        close  = function() Runner:close(true) end,
        kill   = function() Runner:close(true) end
    }

    BuiltinTerminalWrapper = Wrapper:new()
    BuiltinTerminalWrapper:setup {
        create = function()
            vim.cmd[[
                augroup termopen
                    autocmd TermOpen * setlocal statusline=%{b:term_title} | startinsert
                augroup END
                botright vnew
                setlocal shell=fish 
                setlocal nonumber
                setlocal norelativenumber
                term
            ]]
        end,

        open = function(self)
            if self:is_open() then
                local winnr = vim.fn.bufwinnr(self.bufnr)
                vim.cmd(winnr.."wincmd w")
            else
                vim.cmd("botright vnew")
                vim.cmd("b"..self.bufnr)
            end
        end,

        close = function(self)
            local winnr = vim.fn.bufwinnr(self.bufnr)
            vim.cmd(winnr.."wincmd c")
        end,

        kill = function(self)
            vim.cmd("bd! "..self.bufnr)
        end,
    }


    -- Try:

    -- BuiltinTerminalWraper:open {cmd = "echo hi"}
    -- BuiltinTerminalWraper:send_command {cmd = "echo hi again"}
    -- BuiltinTerminalWraper:close()
    -- BuiltinTerminalWraper:toggle()
    -- BuiltinTerminalWraper:kill()
    --

    vim.cmd [[
        command! NpmCI :lua require'FTerm'.scratch({ cmd = "npm ci" })<CR>
        nnoremap <c-t> :lua require'FTerm'.scratch { cmd = "fish" }<CR>
    ]]

    --- Toggle a floating terminal with lazygit
    function _G.lazygit_term()
        return fterm.scratch {
            ft = 'fterm_lazygit',
            cmd = 'lazygit',
            auto_close = true,
        }
    end
end
