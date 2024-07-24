-- TODO:
--    * support [count]dd
--    * support undo deleting
--    * support location-list
--    * support deleting visual blocks
--
--    See :cbuffer and :lbuffer
--    They seem to be useful.

local M = {}

local undo_list = {}

local api = vim.api
local fn = vim.fn
local cmd = vim.cmd
local getqflist = vim.fn.getqflist
local setqflist = vim.fn.setqflist

local function save_old(pos, list)
  pos = pos or vim.api.nvim_win_get_cursor(0)
  list = list or getqflist()
  table.insert(undo_list, { pos, list })
end

---@param key string
function M.select_move(key)
  local owin = api.nvim_get_current_win()
  cmd('normal! ' .. key .. '\r')
  api.nvim_set_current_win(owin)
end

local function qf_delete_line(line, list)
  list = list or getqflist()
  table.remove(list, line)
  setqflist(list)
  return list
end

function M.delete()
  local curpos = vim.api.nvim_win_get_cursor(0)
  local list = getqflist()
  -- save_old(vim.deepcopy(curpos), list)

  local new_list = qf_delete_line(fn.line('.'), list)
  curpos[1] = math.min(curpos[1], #new_list)
  if curpos[1] < 1 then
    cmd('cclose')
    return
  end
  vim.api.nvim_win_set_cursor(0, curpos)
end

return M
