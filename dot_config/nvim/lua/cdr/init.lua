-- TODO:
--      * Truncate at Nth entry
--      * Make preview_cmd non-blocking

local M = {}

local fzf = require('fzf')
local action = require('fzf.actions').action

local cachename = 'chpwd-recent-dirs'

local cache_d = vim.fn.stdpath('cache') --[[@as string]]
local cache = cache_d .. '/' .. cachename

---@type string[]
local recent_dirs = {}

local function sync()
  local new = {}
  local set = {}
  local count = 1
  for _, dir in ipairs(recent_dirs) do
    if not set[dir] then
      set[dir] = count
      count = count + 1
    end
  end
  for dir, idx in pairs(set) do
    new[idx] = dir
  end
  assert(vim.islist(new))
  recent_dirs = new
end

local function load_cache()
  local f = io.open(cache, 'r')
  if not f then
    (io.open(cache, 'w')):close()
    f = io.open(cache, 'r')
  end

  local line_no = 1

  -- there is no way f is nil here but we're silencing diagnostics here
  assert(f ~= nil)
  for line in f:lines() do
    if #line > 0 then
      recent_dirs[line_no] = line
      line_no = line_no + 1
    end
  end
  f:close()
end

local function save_cache()
  local f = io.open(cache, 'w') --[[@as file*]]
  for _, dir in ipairs(recent_dirs) do
    f:write(dir, '\n')
  end
  f:close()
end

local function cd(dir, opt)
  local cmd = opt.cmd or 'cd'
  vim.validate({ dir = { dir, 'string' }, ['opt.cmd'] = { opt.cmd, 'string', true } })
  vim.cmd(string.format('%s %s', cmd, vim.fn.fnameescape(dir)))
end

function M.on_VimLeavePre()
  save_cache()
end

function M.on_DirChanged()
  recent_dirs[#recent_dirs + 1] = vim.fn.getcwd()
  sync()
end

function M.init()
  load_cache()
  M.on_DirChanged()
  vim.cmd([[
    augroup lua_cdr_init
      autocmd!
      autocmd VimLeavePre * lua require('cdr').on_VimLeavePre()
      autocmd DirChanged  * lua require('cdr').on_DirChanged()
    augroup END
  ]])

  vim.api.nvim_create_user_command('Cdr', M.cdr, {
    force = true,
    desc = 'lua require("cdr").cdr()',
  })
  vim.keymap.set('n', '<leader>C', '<cmd>Cdr<cr>', {})
end

function M.cdr()
  coroutine.wrap(function()
    local preview_cmd = action(function(items, _, _)
      return vim.fn.system({
        'exa',
        '--color=always',
        '-algF',
        '--group-directories-first',
        '--git',
        '--git-ignore',
        items[1],
      })
    end)
    local args = vim.tbl_map(vim.fn.fnameescape, recent_dirs)
    local colored_dirs =
      vim.split(vim.fn.system({ 'lscolors', unpack(args) }), '\n', { trimempty = true })
    local dir = fzf.fzf(colored_dirs, '--preview=' .. preview_cmd)
    if dir then
      cd(dir[1], { cmd = 'lcd' })
    end
  end)()
end

function M.debug()
  require('My').dump({ cache = cache, recent_dirs = recent_dirs })
end

return M
