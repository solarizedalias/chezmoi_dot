local M = {}

---@param child table
---@param parent table
local function inherit(child, parent)
  return setmetatable(child, { __index = parent })
end

local bool = require('viml/bool')
local utils = require('viml/utils')
local autocmd = require('viml/autocmd')

---@type table<string, fun()>
M.fn = vim.tbl_extend('error', bool, {})
---@type table<string, fun()>
M.api = {}
M.autocmd = autocmd
M.utils = utils

inherit(M.fn, vim.fn)
inherit(M.api, vim.api)
inherit(M, vim)

return M
