local command = function(name, opts, cb)
  vim.api.nvim_create_user_command(name, cb, opts)
end

local function notify(msg, bang)
  local level = vim.log.levels.INFO
  if bang then
    level = vim.log.levels.ERROR
  end
  vim.notify(msg, level, { title = ':Notify' })
end

command('Notify', {
  force = true,
  nargs = '*',
  bang = true,
  desc = 'vim.notify(...)',
}, function(a)
  notify(a.args, a.bang)
end)

local function ltk(tb_expr, bang)
  local tb, err = loadstring('return ' .. tb_expr)
  if err then
    error(err)
  end

  assert(tb ~= nil)
  local result = vim.tbl_keys(tb())
  if bang then
    result = vim.fn.sort(result)
  end
  result = vim.fn.join(result, '\n')
  return result
end

command('LTK', {
  force = true,
  nargs = 1,
  bang = true,
  complete = 'lua',
  desc = 'LTK = Lua Table Keys',
}, function(a)
  print(ltk(a.args, a.bang))
end)
