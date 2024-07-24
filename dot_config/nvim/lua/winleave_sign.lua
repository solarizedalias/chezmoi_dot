local current_buf = vim.api.nvim_get_current_buf
local current_win = vim.api.nvim_get_current_win

local M = {}

local ignored_filetypes = {
  'TelescopePrompt',
  'which_key',
}
local function should_skip()
  return vim.o.readonly or vim.o.buftype ~= '' or vim.tbl_contains(ignored_filetypes, vim.o.filetype)
end

local default_name = 'cursor'
local default = {
  text = '▶︎',
  texthl = 'DiagnosticError',
}

local internal_id = 0
local function idgen()
  internal_id = internal_id + 1
  return internal_id
end

local ids = {}

local function define()
  vim.fn.sign_define(default_name, default)
end

local function prune()
  for winnr, id in pairs(ids) do
    if not vim.api.nvim_win_is_valid(winnr) then
      vim.fn.sign_unplace(default_name, { id = id })
      ids[winnr] = nil
    end
  end
end
local function unplace()
  local bufnr = current_buf()
  local winnr = current_win()
  if ids[winnr] then
    vim.fn.sign_unplace(default_name, { id = ids[winnr], buffer = bufnr })
    ids[winnr] = nil
  end
end
local function place()
  if should_skip() then
    return
  end
  local bufnr = current_buf()
  local winnr = current_win()
  ids[winnr] = vim.fn.sign_place(idgen(), default_name, default_name, bufnr, {
    lnum = vim.fn.line('.'),
    priority = 20,
  })
end

M.place = place
M.unplace = unplace
M.prune = prune

define()
vim.cmd([[
  augroup WinLeaveSign
    autocmd!
    autocmd WinLeave * lua require('winleave_sign').place()
    autocmd WinEnter * lua require('winleave_sign').unplace()
    autocmd CursorHold * lua require('winleave_sign').prune()
  augroup END
]])

return M
