local function _new(self, t)
  return setmetatable(t or {}, { __index = self })
end
local meta = {
  __index = {
    add_reverse_lookup = vim.tbl_add_reverse_lookup,
    count = vim.count,
    deepcopy = vim.deepcopy,
    deep_equal = vim.deep_equal,
    contains = function(self, value)
      for _, v in pairs(self) do
        if v == value then
          return true
        end
      end
      return false
    end,
    extend = function(self, behavior, ...)
      self = _new(self, vim.tbl_extend(behavior, self, ...))
      return self
    end,
    deep_extend = function(self, behavior, ...)
      self = _new(self, vim.tbl_deep_extend(behavior, self, ...))
      return self
    end,
    filter = function(self, func)
      self = _new(self, vim.tbl_filter(func, self))
      return self
    end,
    flatten = function(self)
      self = _new(self, vim.tbl_flatten(self))
      return self
    end,
    isempty = vim.tbl_isempty,
    keys = vim.tbl_keys,
    map = function(self, func)
      return vim.tbl_map(func, self)
    end,
    values = vim.tbl_values,
  },
}

local M = setmetatable({}, meta)

function M:new(t)
  return setmetatable(t or {}, { __index = self })
end

return M
