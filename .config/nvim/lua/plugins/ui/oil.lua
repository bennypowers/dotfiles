local function parse_output(proc)
  local result = proc:wait()
  local ret = {}
  if result.code == 0 then
    for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
      -- Remove trailing slash
      line = line:gsub("/$", "")
      ret[line] = true
    end
  end
  return ret
end

-- build git status cache
local function new_git_status()
  return setmetatable({}, {
    __index = function(self, key)
      local ignore_proc = vim.system(
        { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
        {
          cwd = key,
          text = true,
        }
      )
      local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
        cwd = key,
        text = true,
      })
      local ret = {
        ignored = parse_output(ignore_proc),
        tracked = parse_output(tracked_proc),
      }

      rawset(self, key, ret)
      return ret
    end,
  })
end

local git_status = new_git_status()

return { 'stevearc/oil.nvim',
  keys = {
    { '-', '<CMD>Oil<CR>', mode = 'n', desc = 'Open parent directory' },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = function()

    -- Clear git status cache on refresh
    local refresh = require'oil.actions'.refresh
    local orig_refresh = refresh.callback
    refresh.callback = function(...)
      git_status = new_git_status()
      orig_refresh(...)
    end

    vim.api.nvim_set_hl(0, 'OilDotFile', vim.tbl_extend(
      'force',
      vim.api.nvim_get_hl(0, { name = 'Oil' }),
      vim.api.nvim_get_hl(0, { name = 'Comment' }),
      { bold = true }
    ))

    return {
      view_options = {
        show_hidden = true,
        is_hidden_file = function(name, bufnr)
          local dir = require'oil'.get_current_dir(bufnr)
          local is_dotfile = vim.startswith(name, '.') and name ~= '..'
          if not dir then
            return is_dotfile
          end
          local status = git_status[dir]
          if is_dotfile then
            return not status.tracked[name]
          else
            return status.ignored[name]
          end
        end,
        highlight_filename = function(entry, is_hidden)
          if vim.startswith(entry.name, '.') and entry.name ~= '..' then
            return 'OilDotFile'
          end
        end
      }
    }
  end
}
