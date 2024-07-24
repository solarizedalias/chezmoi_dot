local repr = require('repr').repr

local M = {}

local tmpfile = vim.fn.tempname()

local cmd = {
  'vim',
  [[+set nomore]],
  ([[+redir! > %s]]):format(tmpfile),
  [[+echo g:dein#_plugins->copy()->map({k, v -> v.path})->values()]],
  '+q',
}

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

  if syscomp.signal == 0 then
    local read = vim.fn.readfile(tmpfile) --[=[@as string[]]=]
    local content = vim
      .iter(read)
      :filter(function(it)
        return it:match('%S+')
      end)
      :join('')

    result = vim.fn.eval(content) --[=[@as string[]]=]
  else
    error(([[
command failed: %s
%s
]]):format(vim.iter(cmd):join(' '), repr(syscomp)))
  end
  return result
end

M.get = get

return M
