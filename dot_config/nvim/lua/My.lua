local M = {}

local repr = require('repr')

M.repr = repr.repr
M.dump = repr.dump

function M.dump_text(...)
  -- extra effort to split every element by '\n' because '\10' would appear as
  -- '^@' in the vim buffer.
  local lines = vim
    .tbl_map(function(it)
      return vim.split(it, '\n')
    end, { M.repr(...) })
    :flatten()
    :totable()

  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(lnum, lines)
end

---@param f fun(...): any
function M.func_src(f)
  vim.validate({ f = { f, 'function' } })
  local info = debug.getinfo(f)
  local src = info.source
  -- remove the leading `@`
  src = src:sub(2, #src)
  local linedefined = info.linedefined
  return src, linedefined
end

---@param f fun(...): any
---@param split_cmd? string
---@return nil
function M.edit_func_src(f, split_cmd)
  split_cmd = split_cmd or 'edit'
  local src, line = M.func_src(f)
  if vim.fn.filereadable(src) >= 1 then
    vim.cmd(split_cmd .. ' ' .. src)
    vim.api.nvim_win_set_cursor(0, { line, 0 })
    vim.cmd('normal! zz')
  else
    vim.notify('cannot find source file', vim.log.levels.ERROR, {
      title = 'edit_func_src()',
    })
  end
end

---@param child table
---@param parent table
function M.inherit(child, parent)
  return setmetatable(child, { __index = parent })
end

return M
