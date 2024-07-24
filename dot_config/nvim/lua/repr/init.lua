local my_inspect = require('repr/inspect')

local M = {}

-- TODO: to fully achive what I want, I probably need to replace vim.inspect

function M.repr(...)
  local reprs = {}
  for i = 1, select('#', ...) do
    local it = select(i, ...)
    table.insert(reprs, my_inspect(it))
  end
  return table.concat(reprs, '\n')
end

function M.dump(...)
  print(M.repr(...))
end

function M._cmd_dump(...)
  M.dump(...)
end
vim.api.nvim_create_user_command('LuaDump', 'lua require("repr")._cmd_dump(<args>)', {
  force = true,
  nargs = 1,
  complete = 'lua',
})

return M
