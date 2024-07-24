local M = {}

---@param win_id number
function M.is_float_win(win_id)
  if not vim.api.nvim_win_is_valid(win_id) then
    return false
  end
  -- We may need error handling
  local config = vim.api.nvim_win_get_config(win_id)
  return config.relative ~= ''
end

---@return number
function M.get_newest_window()
  return vim.fn.win_getid(vim.fn.winnr('$'))
end

function M.close_float_wins()
  while true do
    local top = M.get_newest_window()
    if M.is_float_win(top) then
      vim.api.nvim_win_close(top, true)
    else
      break
    end
  end
end

return M.close_float_wins
