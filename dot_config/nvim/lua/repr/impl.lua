local M = {}

local func_repr_fmt = [[
function(%s)
  <what> = %s
  <source> = %s
  <linedefined> = %d
end]]

local function repr_params(count, va)
  local result = ''
  local i = 1
  while i <= count do
    local name = 'p' .. tostring(i)
    i = i + 1
    result = result .. name
    if i < count + 1 then
      result = result .. ', '
    end
  end
  if va then
    if count > 0 then
      result = result .. ', '
    end
    result = result .. '...'
  end
  return result
end

local function indent(s, level, tab)
  local lines = vim.split(s, '\n')
  local line1, rest = lines[1], vim.list_slice(lines, 2, #lines)

  local indented = vim.tbl_map(function(it)
    return string.rep(tab, level) .. it
  end, rest)
  local result
  result = line1 .. '\n' .. table.concat(indented, '\n')

  return result
end

---@param f function
---@param level number indent level
function M.repr_func(f, level, tab)
  vim.validate({ level = { level, 'number' }, tab = { tab, 'string' } })
  local info = debug.getinfo(f)
  local params = repr_params(info.nparams, info.isvararg)
  return indent(string.format(func_repr_fmt, params, info.what, info.source, info.linedefined), level, tab)
end

return M
