-- Additional package.path

local M = {}

local function discard(_)
  -- Do nothing
end
discard(discard)
--
do
  local home = vim.env['HOME']
  local share = '/usr/local/share'
  local path_suffixes = {
    '?/init.lua',
    '?.lua',
  }
  local path_dirs = {
    home .. '/.luarocks/share/lua/5.1',
    share .. '/luajit-' .. vim.fn.split(jit.version, ' ')[2],
    '.',
  }

  local cpath_suffix = 'lib/lua/5.1/?.so'
  local extra_cpaths = {
    home .. '/.luarocks',
    '.',
  }

  local function prepend(to, path, sep)
    sep = sep or ';'
    vim.validate({
      to = { to, 'string' },
      path = { path, 'string' },
      sep = { sep, 'string' },
    })
    return path .. sep .. to
  end
  -- Suppress unused warnings
  discard(prepend)

  local function append(to, path, sep)
    sep = sep or ';'
    vim.validate({
      to = { to, 'string' },
      path = { path, 'string' },
      sep = { sep, 'string' },
    })
    return to .. sep .. path
  end
  local function append_missing(to, path, sep)
    sep = sep or ';'
    if not vim.tbl_contains(vim.fn.split(to, sep), path) then
      return append(to, path, sep)
    end
    return to
  end

  do
    for _, suf in ipairs(path_suffixes) do
      for _, pdir in ipairs(path_dirs) do
        package.path = append_missing(package.path, pdir .. '/' .. suf)
      end
    end

    for _, cpdir in ipairs(extra_cpaths) do
      package.cpath = append_missing(package.cpath, cpdir .. '/' .. cpath_suffix)
    end
  end
end

-- Global functions
--

---@param module string
---@return boolean
local function is_loaded(module)
  return package.loaded[module] ~= nil
end
_G.is_loaded = is_loaded

---unload require()'d module
---@param module string
function M.unrequire(module)
  vim.validate({ module = { module, 'string' } })
  if vim.tbl_contains(vim.tbl_keys(package.loaded), module) then
    package.loaded[module] = nil
  end
end
_G.unrequire = M.unrequire

---@param module string
function M.reload(module)
  M.unrequire(module)
  return require(module)
end
_G.reload = M.reload

local My = require('My')

_G.My = My
_G.dump = My.dump
_G.repr = My.repr

function M.eval(expr)
  local chunk, err = loadstring('return ' .. expr)
  if not chunk then
    error(err)
  end
  return chunk()
end
_G.eval = M.eval

do
  local add_command = vim.api.nvim_create_user_command

  local function list_lua_mods(a)
    local list = vim.tbl_keys(package.loaded)
    if a.bang then
      list = vim.fn.sort(list)
    end
    print(table.concat(list, '\n'))
  end

  local function dump_lua_mod(mod)
    My.dump(package.loaded[mod])
  end

  local function cmd_LuaMods(a)
    if #a.args > 0 then
      dump_lua_mod(a.args)
    else
      list_lua_mods(a)
    end
  end

  ---@return string[]
  local function complete_loaded_modules(arglead, _cmdline, _cursorpos)
    discard({ _cmdline, _cursorpos })
    local list = vim.tbl_keys(package.loaded)
    list = vim.tbl_filter(function(it)
      return vim.startswith(it, arglead)
    end, list)
    list = vim.fn.sort(list)
    return list
  end

  add_command('LuaMod', cmd_LuaMods, {
    force = true,
    nargs = '?',
    bang = true,
    desc = 'print(table.concat(vim.tbl_keys(package.loaded), "\\n"))',
    complete = complete_loaded_modules,
  })

  local function unrequire_cmd(arg)
    return M.unrequire(arg.args)
  end
  add_command('Unrequire', unrequire_cmd, {
    force = true,
    nargs = 1,
    desc = 'unrequire("module")',
    complete = complete_loaded_modules,
  })
  local function reload_cmd(arg)
    return M.reload(arg.args)
  end
  add_command('Reload', reload_cmd, {
    force = true,
    nargs = 1,
    desc = 'reload("module")',
    complete = complete_loaded_modules,
  })
end

local viml = require('viml')
_G.viml = viml

return M
