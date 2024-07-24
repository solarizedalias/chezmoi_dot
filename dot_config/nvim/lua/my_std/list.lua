local meta = {
  __index = {
    join = table.concat,
    ---@type fun(self: table): boolean
    contains = vim.tbl_contains,
    count = vim.tbl_count,
    insert = table.insert,
    maxn = table.maxn,
    sort = table.sort,
  },
}

local M = setmetatable({}, meta)

function M:new(t)
  return setmetatable(t or {}, { __index = self })
end

function M:len()
  return #self
end

function M:add(...)
  for i = 1, select('#', ...) do
    self[#self + i] = select(i, ...)
  end
end

function M:slice(i, j)
  return { unpack(self, i, j) }
end

return M
