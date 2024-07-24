local M = {}

local fn = vim.fn
local bool = require('viml/bool')
local validate = vim.validate

---@param major  number
---@param minor? number
---@param patch? number
---@return string
local function version_to_s(major, minor, patch)
  local result = tostring(major)
  if minor then
    result = result .. '.' .. minor
  end
  if patch then
    result = result .. '.' .. patch
  end
  return result
end

---@param major  number
---@param minor? number
---@param patch? number
---@return boolean
function M.has_nvim(major, minor, patch)
  validate({
    major = { major, 'number' },
    minor = { minor, 'number', true },
    patch = { patch, 'number', true },
  })
  return bool.has('nvim-' .. version_to_s(major, minor, patch))
end

---@param patch number
function M.has_patch(patch)
  validate({ patch = { patch, 'string' } })
  return bool.has('patch-' .. patch)
end

function M.nvim_version()
  local v = vim.version()
  return fn.join({ v.major, v.minor, v.patch }, '.')
end

return M
