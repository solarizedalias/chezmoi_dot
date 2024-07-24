local M = {}

---@type number
local ns = vim.api.nvim_create_namespace('custom-ale')
local sign_priority = vim.g.ale_sign_priority or 10
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      return string.format('ALE: %s', diagnostic.message)
    end,
  },
  float = {
    format = function(diagnostic)
      return string.format('ALE: %s', diagnostic.message)
    end,
  },
  signs = { priority = sign_priority },
  severity_sort = true,
}, ns)

local function get_ale_diagnostics(bufnr)
  local bufnr_as_s = tostring(bufnr)
  local ale_buffer_info = vim.g.ale_buffer_info and vim.g.ale_buffer_info[bufnr_as_s]
  local raw_loclist = ale_buffer_info and ale_buffer_info.loclist
  if not raw_loclist then
    return {}
  end
  return vim.tbl_map(function(v)
    -- Some required fields for vim.diagnostic.fromqflist are missing in
    -- g:ale_buffer_info. So we add those as fallbacks
    return vim.tbl_extend('keep', v, { valid = 1, end_lnum = 0, end_col = 0 })
  end, raw_loclist)
end

local function from_ale_loclist(bufnr)
  local ale_loclist = get_ale_diagnostics(bufnr)
  return vim.diagnostic.fromqflist(ale_loclist)
end

---@param bufnr number
local function set_from_ale(bufnr)
  vim.diagnostic.set(ns, bufnr, from_ale_loclist(bufnr))
end

---@param bufnr number
local function reset(bufnr)
  vim.diagnostic.reset(ns, bufnr)
end

---@param bufnr? number
---@param diagnostics? table
---@param opts? table
function M.show(bufnr, diagnostics, opts)
  vim.diagnostic.show(ns, bufnr, diagnostics, opts)
end

---@param bufnr number
function M.hide(bufnr)
  vim.diagnostic.hide(ns, bufnr)
end

local function disable_builtin_signs()
  vim.g.ale_set_signs = 0
  vim.g.ale_virtualtext_cursor = 0
end

function M.on_ALELintPost()
  set_from_ale(vim.fn.bufnr())
  -- TODO make this kind of hooks configureable
  vim.cmd([[ silent! call lightline#update() ]])
end

function M.reset()
  reset(vim.fn.bufnr())
end

local function setup_hook()
  vim.cmd([[
    augroup Custom_ALE
      autocmd!
      autocmd User ALELintPost lua require('custom/ale').on_ALELintPost()
    augroup END
  ]])
end

function M.setup()
  setup_hook()
  disable_builtin_signs()
end

return M
