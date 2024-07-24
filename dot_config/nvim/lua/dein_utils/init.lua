local M = {}

---@param plugin? string
local function dein_get(plugin)
  return vim.fn['dein#get'](plugin)
end

local function plugin_not_found(plugin)
  vim.notify('cannot find plugin: ' .. plugin, vim.log.levels.ERROR, {
    title = 'dein_utils',
  })
end

---@param plugin string
---@return string | nil
function M.plugin_path(plugin)
  vim.validate({ plugin = { plugin, 'string' } })
  return dein_get(plugin).path
end

---@param plugin string
---@param body fun(dir: string): any
local function check_plugin(plugin, body)
  local dir = M.plugin_path(plugin)
  if dir and vim.fn.isdirectory(dir) then
    return body(dir)
  else
    plugin_not_found(plugin)
  end
end

---@param plugin string
function M.cd(plugin)
  check_plugin(plugin, function(dir)
    vim.api.nvim_set_current_dir(dir)
  end)
end

local function term(...)
  vim.cmd(('botright vsplit term://%s'):format(table.concat({ ... }, ' ')))
end

---@param plugin string
function M.log(plugin)
  check_plugin(plugin, function(dir)
    term('git', '-C', dir, 'log', '-p')
  end)
end

-- XXX: to get the proper url,
--      `git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}'`
--      might be useful
function M.open_github(plugin)
  local repo = dein_get(plugin).repo
  if repo then
    vim.fn.system({ 'open', 'https://github.com/' .. repo })
  end
end

local function cmd_DeinLog(arg)
  M.log(arg.args)
end

local function cmd_DeinOpenGH(arg)
  M.open_github(arg.args)
end

local function cmd_DeinCleanUnused()
  M.clean_unused()
end

local toml = require('toml')
local function clean_unused_old()
  local vim_toml = vim.env.HOME .. '/dotfiles/.dein/vim.toml'
  local t = toml.parse_file(vim_toml).plugins

  ---@type string[]
  t = vim.tbl_map(function(v)
    return vim.env.HOME .. '/dotfiles/.config/nvim/bundles/repos/github.com/' .. v.repo
  end, t)

  local unused = vim.fn['dein#check_clean']()

  ---@type string[]
  unused = vim.tbl_filter(function(v)
    return not vim.list_contains(t, v)
  end, unused)
  return vim.tbl_map(function(v)
    -- print(string.format([[remove %s]], v))
    return vim.fn['dein#install#_rm'](v)
  end, unused)
end

M._clean_unused_old = clean_unused_old

function M.clean_unused()
  local get = require('dein_utils/clean').get
  local dein_vim_plugins = get()
  table.sort(dein_vim_plugins)
  local unused = vim.fn['dein#check_clean']()
  table.sort(unused)

  ---@type string[]
  local targets = vim
    .iter(unused)
    :filter(function(it)
      return not vim.tbl_contains(dein_vim_plugins, it)
    end)
    :totable()

  if #targets == 0 then
    print([[no plugins to remove]])
    return
  else
    print(table.concat(targets, '\n'))
    if
      vim.fn.confirm([[These plugins are to be removed. You sure about that?]], '&Yes\n&No') ~= 1
    then
      return
    end
  end

  return vim
    .iter(targets)
    :map(function(it)
      return vim.fn['dein#install#_rm'](it)
    end)
    :totable()
end

local add_command = vim.api.nvim_create_user_command

-- HACK: depends on haya14busa/dein-command.vim
local cmd_opt = { nargs = 1, complete = 'customlist,dein#command#update#complete' }
function M.init()
  add_command('DeinLog', cmd_DeinLog, cmd_opt)
  add_command('DeinOpenGH', cmd_DeinOpenGH, cmd_opt)
  add_command('DeinCleanUnuseed', cmd_DeinCleanUnused, { nargs = 0 })
end

return M
