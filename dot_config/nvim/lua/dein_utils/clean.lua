local repr = require('repr').repr

local M = {}

local tmpfile = vim.fn.tempname()

local code = {
  'try',
  '  echo g:dein#_plugins->copy()->map({k, v -> v.path})->values()',
  'catch',
  '  cquit 1',
  'endtry',
  'quit',
}

---@param code string[]
---@return string
local function make_script(code)
  local file = vim.fn.tempname()
  vim.fn.writefile(code, file)
  return file
end

local cmd = {
  'vim',
  [[+set nomore]],
  ([[+redir! > %s]]):format(tmpfile),
  '-S',
  make_script(code),
  '+q',
}

---@return string[]
local function get()
  local result = {}

  local sysobj = vim.system(cmd, {
    text = true,
    env = {
      VIM = [[]],
      VIMRUNTIME = [[]],
      MYVIMRC = [[]],
    },
  })

  local syscomp = sysobj:wait()

  if syscomp.code == 0 then
    local read = vim.fn.readfile(tmpfile) --[=[@as string[]]=]
    local content = vim
      .iter(read)
      :filter(function(it)
        return it:match('%S+')
      end)
      :join('')

    result = vim.fn.eval(content) --[=[@as string[]]=]
  else
    --     error(([[
    -- command failed: %s
    -- %s
    -- ]]):format(vim.iter(cmd):join(' '), repr(syscomp)))
    result = {}
  end
  return result
end

M.get_vim_plugins = get

return M
