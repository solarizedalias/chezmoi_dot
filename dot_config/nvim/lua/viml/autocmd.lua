local M = {}

local vcmd = vim.cmd

-- XXX ++once and ++nested are not supported

---@param event string
---@param pattern string
---@param cmd string
function M.autocmd(event, pattern, cmd)
  vcmd(string.format('  autocmd %s %s %s', event, pattern, cmd))
end

---@class Autocmd
---@field event string
---@field pattern string
---@field cmd string

---@param name string
---@param aucmds Autocmd[]
function M.augroup(name, aucmds)
  vcmd(string.format([[augroup %s]], name))
  for _, aucmd in ipairs(aucmds) do
    M.autocmd(aucmd.event, aucmd.pattern, aucmd.cmd)
  end
  vcmd('augroup END')
end

return M
