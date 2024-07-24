local M = {}

---@type table<string, number>
local levels = {
  errors = vim.diagnostic.severity.ERROR,
  warnings = vim.diagnostic.severity.WARN,
  info = vim.diagnostic.severity.INFO,
  hints = vim.diagnostic.severity.HINT,

  done = 0,
  not_yet = -1,
}

---@type fun(n: number): string
local nr2char = vim.fn.nr2char

local signs = {
  [levels.errors] = nr2char(0xf05e),
  [levels.warnings] = nr2char(0xf071),
  [levels.info] = nr2char(0xf129),
  [levels.hints] = nr2char(0xf0f3),

  [levels.not_yet] = nr2char(0xf110) .. ' ',
  [levels.done] = nr2char(0xf00c) .. ' ',
}

local function join(list)
  local result = ''
  for _, s in ipairs(list) do
    if #s > 0 then
      result = result .. ' ' .. s
    end
  end
  return result
end

local function ale_is_checking_buffer(bufnr)
  if vim.fn.exists('*ale#engine#IsCheckingBuffer') == 0 then
    return false
  end
  return vim.fn['ale#engine#IsCheckingBuffer'](bufnr) ~= 0
end

local function lsp_has_pending_requests(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if #client.requests > 0 then
      return true
    end
  end
  return false
end

local function has_pending(bufnr)
  return ale_is_checking_buffer(bufnr) or lsp_has_pending_requests(bufnr)
end

local function get_count(bufnr, level)
  return #vim.diagnostic.get(bufnr, { severity = level })
end

-- PERF: M.diagnostic_component is called for every severity level.
--       We could change that.

function M.diagnostic_component(bufnr, level)
  local result = ''
  if level == levels.not_yet then
    if has_pending(bufnr) then
      result = signs[level]
    end
  elseif level == levels.done then
    if has_pending(bufnr) then
      return result
    end
    for i, _ in ipairs(vim.diagnostic.severity) do
      if get_count(bufnr, i) > 0 then
        return result
      end
    end
    result = signs[level]
  else
    local count = get_count(bufnr, level)
    if count > 0 then
      result = string.format('%s %d', signs[level], count)
    end
  end
  return result
end

function M.diagnostic()
  local bufnr = vim.api.nvim_get_current_buf()
  local function c(level)
    return M.diagnostic_component(bufnr, level)
  end

  local result = join({ c(levels.errors), c(levels.warnings), c(levels.info), c(levels.hints) })
  if #result > 0 then
    return result
  else
    if has_pending(bufnr) then
      return signs[levels.not_yet]
    end
    return signs[levels.done]
  end
end

return M
