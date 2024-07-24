local close_float_wins = require('my_maps/close_float_wins')

---@param mode string|string[]
---@param lhs string
---@param cb function
---@param desc string?
---@param expr? boolean
local function map(mode, lhs, cb, desc, expr)
  desc = desc or ''
  expr = expr or false
  vim.keymap.set(mode, lhs, cb, { noremap = true, silent = true, desc = desc, expr = expr })
end

map('n', '<esc>', close_float_wins)

-- smap
map({ 's' }, '<c-n>', function()
  if vim.snippet.active({ direction = 1 }) then
    return '<cmd>lua vim.snippet.jump(1)<cr>'
  else
    return '<c-n>'
  end
end, '<cmd>lua vim.snippet.jump(1)<cr> or <c-n>', true)

map({ 's' }, '<c-p>', function()
  if vim.snippet.active({ direction = -1 }) then
    return '<cmd>lua vim.snippet.jump(-1)<cr>'
  else
    return '<c-p>'
  end
end, '<cmd>lua vim.snippet.jump(-1)<cr> or <c-p>', true)
