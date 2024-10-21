---@class ClipboardDef
---@field name string
---@field copy {['+']: string|string[], ['*']: string|string[]}
---@field paste {['+']: string|string[], ['*']: string|string[]}

local M = {}

---@type ClipboardDef
local win32yank = {
  name = 'wsl',
  copy = {
    ['+'] = { 'win32yank.exe', '-i', '--crlf' },
    ['*'] = { 'win32yank.exe', '-i', '--crlf' },
  },
  paste = {
    ['+'] = { 'win32yank.exe', '-o', '--lf' },
    ['*'] = { 'win32yank.exe', '-o', '--lf' },
  },
  cache_enabled = 1,
}

---@type ClipboardDef
local pb = {
  name = 'macOS',
  copy = {
    ['+'] = 'pbcopy',
    ['*'] = 'pbcopy',
  },
  paste = {
    ['+'] = 'pbpaste',
    ['*'] = 'pbpaste',
  },
}

local map = {
  ['win32yank.exe'] = win32yank,
  pbcopy = pb,
}

local copy_cmds = {}
setmetatable(copy_cmds, {
  __index = function(_, key)
    return vim.fn.executable(key) == 1
  end,
})

local cmd_list = {
  'pbcopy',
  'win32yank.exe',
}

function M.init()
  ---@type string
  local cmd = vim.iter(cmd_list):find(function(it)
    return copy_cmds[it]
  end)

  if cmd then
    vim.g.clipboard = map[cmd]
  end
end

return M
