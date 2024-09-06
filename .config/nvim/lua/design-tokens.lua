local M = {}

local function read_file(filename)
  return io.open(filename, 'r'):read('*a')
end

local function read_tokens(json_file_path)
  local expanded = vim.fn.expand(json_file_path)
  local did_read, contents = pcall(read_file,expanded)
  if not did_read then vim.notify('could not read '..json_file_path .. ' ' .. contents)
  else
    local did_parse, json = pcall(vim.json.decode,contents)
    if not did_parse then vim.notify('could not parse '..json_file_path)
    else
      return json
    end
  end
end

local function flatten_tokens(deep_tokens)
  local flattened_tokens = {}

  local function get_child_tokens(_, child)
    if (type(child) == 'table') then
      if child['$value'] then
        table.insert(flattened_tokens,child)
      else
        vim.iter(child)
          :each(get_child_tokens)
      end
    end
  end

  vim.iter(deep_tokens)
    :each(get_child_tokens)

  return flattened_tokens
end

function M.read_flattened_tokens(path)
  local tokens = read_tokens(path);
  if tokens then
    return flatten_tokens(tokens)
  else
    return {}
  end
end

return M
