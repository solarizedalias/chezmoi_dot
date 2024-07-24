local M = {}

---@param expr number
---@return boolean
function M.bool(expr)
  return expr ~= 0
end

function M.number(expr)
  if expr then
    return 1
  end
  return 0
end

-- Vim builtin bool returing functions

---@param buf number
---@param lnum number
---@param text string
---@return boolean
function M.appendbufline(buf, lnum, text)
  return vim.fn.appendbufline(buf, lnum, text) == 0
end

---@param cmd string
function M.assert_beeps(cmd)
  return vim.fn.assert_beeps(cmd) ~= 0
end

---@param msg? string
function M.assert_equal(exp, act, msg)
  return vim.fn.assert_equal(exp, act, msg) ~= 0
end

-- TODO more assert_X

---@param buf string|number
---@return boolean
function M.bufexists(buf)
  return vim.fn.bufexists(buf) ~= 0
end

---@param buf string|number
---@return boolean
function M.buflisted(buf)
  return vim.fn.buflisted(buf) ~= 0
end

---@param buf string|number
---@return boolean
function M.bufloaded(buf)
  return vim.fn.bufloaded(buf) ~= 0
end

function M.complete_add(expr)
  return vim.fn.complete_add(expr) ~= 0
end

function M.complete_check()
  return vim.fn.complete_check() ~= 0
end

---@param buf number
---@param first? number FIXME
---@param last? number  FIXME
function M.deletebufline(buf, first, last)
  return vim.fn.deletebufline(buf, first, last) == 0
end

---@return boolean
function M.did_filetype()
  return vim.fn.did_filetype() ~= 0
end

function M.empty(expr)
  return vim.fn.empty(expr) ~= 0
end

function M.eventhandler()
  return vim.fn.eventhandler() ~= 0
end

function M.executable(expr)
  return vim.fn.executable(expr) ~= 0
end

---@param expr string
---@return boolean|number
function M.exists(expr)
  local result = vim.fn.exists(expr)
  if result == 0 then
    return false
  end
  return result
end

---@param lnum number
---@return boolean | number
function M.foldclosed(lnum)
  local result = vim.fn.foldclosed(lnum)
  if result == -1 then
    return false
  end
  return result
end

---@param lnum number
---@return boolean | number
function M.foldclosedend(lnum)
  local result = vim.fn.foldclosedend(lnum)
  if result == -1 then
    return false
  end
  return result
end

---@param file string
---@return boolean
function M.filereadable(file)
  return vim.fn.filereadable(file) ~= 0
end

---@param file string
---@return boolean
function M.filewritable(file)
  return vim.fn.filewritable(file) ~= 0
end

---@param feature string
---@return boolean
function M.has(feature)
  return vim.fn.has(feature) ~= 0
end

---@param dict table
---@param key string
---@return boolean
function M.has_key(dict, key)
  return vim.fn.has_key(dict, key) ~= 0
end

---@param winnr number
---@param tabnr? number
---@return boolean
function M.haslocaldir(winnr, tabnr)
  if not tabnr then
    tabnr = 0
  end
  return vim.fn.haslocaldir(winnr, tabnr) ~= 0
end

---@param  what string
---@param  mode? string nvxsoilc
---@param  abbr? boolean
---@return boolean
function M.hasmapto(what, mode, abbr)
  return vim.fn.hasmapto(what, mode, abbr) ~= 0
end

---@alias history
---| '"cmd"'
---| '":"'
---| '"search"'
---| '"/"'
---| '"expr"'
---| '"="'
---| '"input"'
---| '"@"'
---| '">"'
---| '"debug"'
---| '""'

---@param history history
---@param item string
---@return boolean
function M.histadd(history, item)
  return vim.fn.histadd(history, item) ~= 0
end

---@param history history
---@param item? string|number
---@return boolean
function M.histdel(history, item)
  return vim.fn.histdel(history, item) ~= 0
end

---@param name string
---@return boolean
function M.hlexists(name)
  return vim.fn.hlexists(name) ~= 0
end

---@param directory string
---@return boolean
function M.isdirectory(directory)
  return vim.fn.isdirectory(directory) ~= 0
end

---@param expr any
---@return '1' | '-1' | 'false'
function M.isinf(expr)
  local r = vim.fn.isinf(expr)
  if r == 0 then
    return false
  end
  return r
end

---@param expr string
---@return boolean
function M.islocked(expr)
  return vim.fn.islocked(expr) ~= 0
end

---@param expr any
---@return boolean
function M.isnan(expr)
  return vim.fn.isnan(expr) ~= 0
end

---@param expr string[] | string
---@param pat string
---@param start? number
---@param count? number
---@return boolean | number
function M.match(expr, pat, start, count)
  local result = vim.fn.match(expr, pat, start, count)
  if result == -1 then
    return false
  end
  return result
end

---@param name string
---@param path? '"p"' | '""'
---@param prot? number protection bits of the new directory
---@return boolean
function M.mkdir(name, path, prot)
  return vim.fn.mkdir(name, path, prot) ~= 0
end

---@return boolean
function M.pumvisible()
  return vim.fn.pumvisible() ~= 0
end

---@param from string
---@param to string
---@return boolean
function M.rename(from, to)
  return vim.fn.rename(from, to) == 0
end

function M.serverstop(address)
  return vim.fn.serverstop(address) ~= 0
end

---returns false when successful, true when not editing the command line.
---@param pos number >= 1
---@return boolean
function M.setcmdpos(pos)
  return vim.fn.setcmdpos(pos) ~= 0
end

---@param list table
---@param win? number
function M.setmatches(list, win)
  return vim.fn.setmatches(list, win) == 0
end

---@param fname string
---@param mode number
---@return boolean
function M.setfperm(fname, mode)
  return vim.fn.setfperm(fname, mode) ~= 0
end

---if this succeeds, false is returned. if this fails (most likely because
---{lnum} is invalid) true is returned.
---@param lnum number
---@param text string
---@return boolean
function M.setline(lnum, text)
  return vim.fn.setline(lnum, text) ~= 0
end

---@param timeout number
---@param condition string | function
---@param interval? number
---@return boolean | number
function M.wait(timeout, condition, interval)
  local result = vim.fn.wait(timeout, condition, interval)
  if result ~= 0 then
    return result
  end
  return true
end

---@return boolean
function M.wildmenumode()
  return vim.fn.wildmenumode() ~= 0
end

---@param expr number
---@return boolean
function M.win_gotoid(expr)
  return vim.fn.win_gotoid(expr) ~= 0
end

return M
