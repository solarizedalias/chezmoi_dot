local levels = vim.log.levels
local notify = vim.notify
local validate = vim.validate

local M = {}

---@param msg string
function M.log(msg)
  validate({ msg = { msg, 'string' } })
  notify(msg, levels.DEBUG, { title = debug.getinfo(2).name or '<unknown>' })
end

return M
