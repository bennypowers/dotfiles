local function is_callable(x)
    if type(x) == 'function' then
        return true
    elseif type(x) == 'table' then
        -- It would be elegant and quick to say
        -- `return iscallable(debug.getmetatable(x))`
        -- but that is actually not quite correct
        -- (at least in my experiments), since it appears
        -- that the `__call` metamethod must be a *function* value
        -- (and not some table that has been made callable)
        local mt = debug.getmetatable(x)
        return type(mt) == 'table' and type(mt.__call) == 'function'
    else
        return false
    end
end

local function check_functions(items)
  for _, item in ipairs(items) do
    if not is_callable(item) then
      error('Not callable', 2)
    end
  end
  return items
end

--- functional programming helpers
local M = {}

function M.map(fn)
  return function(t)
    return vim.tbl_map(fn, t)
  end
end

function M.filter(fn)
  return function(t)
    return vim.tbl_filter(fn, t)
  end
end

function M.reduce(fn, init)
  return function(t)
    local acc = init
    for i, x in ipairs(t) do
      acc = fn(acc, x, i)
    end
    return acc
  end
end

--- Nary compose, left-to-right
--- https://stackoverflow.com/questions/27170825/composing-two-functions-in-lua
function M.pipe(...)
  local fnchain = check_functions {...}
  local function recurse(i, ...)
    if i == #fnchain then return fnchain[i](...) end
    return recurse(i + 1, fnchain[i](...))
  end
  return function(...) return recurse(1, ...) end
end

function M.trace(x)
  print(vim.inspect(x))
  return x
end

return M
