local vim = vim
local api = vim.api
local npcall = vim.F.npcall
local validate = vim.validate
local util = vim.lsp.util
local M = {}

-- Reuse -----------------------------------------------------

M.stylize_markdown = util.stylize_markdown

local default_border = {
  { '', 'NormalFloat' },
  { '', 'NormalFloat' },
  { '', 'NormalFloat' },
  { ' ', 'NormalFloat' },
  { '', 'NormalFloat' },
  { '', 'NormalFloat' },
  { '', 'NormalFloat' },
  { ' ', 'NormalFloat' },
}

---@class BorderSize
---@field height number
---@field width number

---@param opts? table<string, any>
---@return BorderSize
local function get_border_size(opts)
  local border = opts and opts.border or default_border
  local height = 0
  local width = 0

  if type(border) == 'string' then
    local border_size = {
      none = { 0, 0 },
      single = { 2, 2 },
      double = { 2, 2 },
      rounded = { 2, 2 },
      solid = { 2, 2 },
      shadow = { 1, 1 },
    }
    if border_size[border] == nil then
      error(
        'floating preview border is not correct. Please refer to the docs |vim.api.nvim_open_win()|'
          .. vim.inspect(border)
      )
    end
    height, width = unpack(border_size[border])
  else
    ---@private
    local function border_width(id)
      if type(border[id]) == 'table' then
        -- border specified as a table of <character, highlight group>
        return vim.fn.strdisplaywidth(border[id][1])
      elseif type(border[id]) == 'string' then
        -- border specified as a list of border characters
        return vim.fn.strdisplaywidth(border[id])
      end
      error(
        'floating preview border is not correct. Please refer to the docs |vim.api.nvim_open_win()|'
          .. vim.inspect(border)
      )
    end
    ---@private
    local function border_height(id)
      if type(border[id]) == 'table' then
        -- border specified as a table of <character, highlight group>
        return #border[id][1] > 0 and 1 or 0
      elseif type(border[id]) == 'string' then
        -- border specified as a list of border characters
        return #border[id] > 0 and 1 or 0
      end
      error(
        'floating preview border is not correct. Please refer to the docs |vim.api.nvim_open_win()|'
          .. vim.inspect(border)
      )
    end
    height = height + border_height(2) -- top
    height = height + border_height(6) -- bottom
    width = width + border_width(4) -- right
    width = width + border_width(8) -- left
  end

  return { height = height, width = width }
end

---@private
---@param name string
---@param value boolean|string|number
---@return number|nil
local function find_window_by_var(name, value)
  for _, win in ipairs(api.nvim_list_wins()) do
    if npcall(api.nvim_win_get_var, win, name) == value then
      return win
    end
  end
end

---@param contents string[]
---@param opts? table
---@return string[]
local function _trim_fb(contents, opts)
  validate({ contents = { contents, 't' }, opts = { opts, 't', true } })
  opts = opts or {}
  contents = M.trim_empty_lines(contents)
  if opts.pad_top then
    for _ = 1, opts.pad_top do
      table.insert(contents, 1, '')
    end
  end
  if opts.pad_bottom then
    for _ = 1, opts.pad_bottom do
      table.insert(contents, '')
    end
  end
  return contents
end

M._trim = util._trim or _trim_fb

---@param lines string[]
---@return string[]
local function trim_empty_lines_fb(lines)
  local start = 1
  for i = 1, #lines do
    if lines[i] and #lines[i] > 0 then
      start = i
      break
    end
  end
  local finish = 1
  for i = #lines, 1, -1 do
    if lines[i] and #lines[i] > 0 then
      finish = i
      break
    end
  end
  return vim.list_extend({}, lines, start, finish)
end
M.trim_empty_lines = trim_empty_lines_fb

---@param contents table
---@param opts table|nil
local function _make_floating_popup_size_fb(contents, opts)
  validate({ contents = { contents, 't' }, opts = { opts, 't', true } })
  opts = opts or {}

  local width = opts.width
  local height = opts.height
  local wrap_at = opts.wrap_at
  local max_width = opts.max_width
  local max_height = opts.max_height
  local line_widths = {}

  if not width then
    width = 0
    for i, line in ipairs(contents) do
      -- TODO(ashkan) use nvim_strdisplaywidth if/when that is introduced.
      line_widths[i] = vim.fn.strdisplaywidth(line)
      width = math.max(line_widths[i], width)
    end
  end

  local border_width = get_border_size(opts).width
  local screen_width = api.nvim_win_get_width(0)
  width = math.min(width, screen_width)

  -- make sure borders are always inside the screen
  if width + border_width > screen_width then
    width = width - (width + border_width - screen_width)
  end

  if wrap_at and wrap_at > width then
    wrap_at = width
  end

  if max_width then
    width = math.min(width, max_width)
    wrap_at = math.min(wrap_at or max_width, max_width)
  end

  if not height then
    height = #contents
    if wrap_at and width >= wrap_at then
      height = 0
      if vim.tbl_isempty(line_widths) then
        for _, line in ipairs(contents) do
          local line_width = vim.fn.strdisplaywidth(line)
          height = height + math.ceil(line_width / wrap_at)
        end
      else
        for i = 1, #contents do
          height = height + math.max(1, math.ceil(line_widths[i] / wrap_at))
        end
      end
    end
  end
  if max_height then
    height = math.min(height, max_height)
  end

  return width, height
end
M._make_floating_popup_size = util._make_floating_popup_size or _make_floating_popup_size_fb

---@param width number
---@param height number
---@param opts table|nil
local function make_floating_popup_options_fb(width, height, opts)
  validate({ opts = { opts, 't', true } })
  opts = opts or {}
  validate({
    ['opts.offset_x'] = { opts.offset_x, 'n', true },
    ['opts.offset_y'] = { opts.offset_y, 'n', true },
  })

  local anchor = ''
  local row, col

  local lines_above = vim.fn.winline() - 1
  local lines_below = vim.fn.winheight(0) - lines_above

  if lines_above < lines_below then
    anchor = anchor .. 'N'
    height = math.min(lines_below, height)
    row = 1
  else
    anchor = anchor .. 'S'
    height = math.min(lines_above, height)
    row = -get_border_size(opts).height
  end

  if vim.fn.wincol() + width + (opts.offset_x or 0) <= api.nvim_get_option_value('columns', {}) then
    anchor = anchor .. 'W'
    col = 0
  else
    anchor = anchor .. 'E'
    col = 1
  end

  return {
    anchor = anchor,
    col = col + (opts.offset_x or 0),
    height = height,
    focusable = opts.focusable,
    relative = 'cursor',
    row = row + (opts.offset_y or 0),
    style = 'minimal',
    width = width,
    border = opts.border or default_border,
    zindex = opts.zindex or 50,
  }
end
M.make_floating_popup_options = util.make_floating_popup_options or make_floating_popup_options_fb

---@param method string
---@param params? table
---@param handler? fun(err, result, ctx, config): table|nil, table
---@return table<number, number>[], fun()
local function request(method, params, handler)
  validate({ method = { method, 's' }, handler = { handler, 'f', true } })
  return vim.lsp.buf_request(0, method, params, handler)
end

---@param method string
---@param params? table
---@param timeout? number
---@return table<number, table> | nil, string|nil
local function request_sync(method, params, timeout)
  validate({ method = { method, 's' } })
  return vim.lsp.buf_request_sync(0, method, params, timeout or 1000)
end

-------------------------------------------------------------

---@private
--- Closes the preview window
---
---@param winnr number window id of preview window
---@param bufnrs table|nil optional list of ignored buffers
local function close_preview_window(winnr, bufnrs)
  vim.schedule(function()
    -- exit if we are in one of ignored buffers
    if bufnrs and vim.tbl_contains(bufnrs, api.nvim_get_current_buf()) then
      return
    end

    local augroup = 'preview_window_' .. winnr
    pcall(api.nvim_del_augroup_by_name, augroup)
    pcall(api.nvim_win_close, winnr, true)
  end)
end

---@private
--- Creates autocommands to close a preview window when events happen.
---
---@param events table list of events
---@param winnr number window id of preview window
---@param bufnrs table list of buffers where the preview window will remain visible
---@see |autocmd-events|
local function close_preview_autocmd(events, winnr, bufnrs)
  local augroup = api.nvim_create_augroup('preview_window_' .. winnr, {
    clear = true,
  })

  -- close the preview window when entered a buffer that is not
  -- the floating window buffer or the buffer that spawned it
  api.nvim_create_autocmd('BufEnter', {
    group = augroup,
    callback = function()
      close_preview_window(winnr, bufnrs)
    end,
  })

  if #events > 0 then
    api.nvim_create_autocmd(events, {
      group = augroup,
      buffer = bufnrs[2],
      callback = function()
        close_preview_window(winnr)
      end,
    })
  end
end

---@param contents string[] table of lines to show in window
---@param syntax   string   string of syntax to set for opened buffer
---@param opts     table    table with optional fields (additional keys are passed on to |nvim_open_win()|)
---                           - height: (number) height of floating window
---                           - width: (number) width of floating window
---                           - wrap: (boolean, default true) wrap long lines
---                           - wrap_at: (number) character to wrap at for computing height when wrap is enabled
---                           - max_width: (number) maximal width of floating window
---                           - max_height: (number) maximal height of floating window
---                           - pad_top: (number) number of lines to pad contents at top
---                           - pad_bottom: (number) number of lines to pad contents at bottom
---                           - focus_id: (string) if a popup with this id is opened, then focus it
---                           - close_events: (table) list of events that closes the floating window
---                           - focusable: (boolean, default true) Make float focusable
---                           - focus: (boolean, default true) If `true`, and if {focusable}
---                                    is also `true`, focus an existing floating window with the same
---                                    {focus_id}
---@return number, number   buffer and window number of the newly created floating
---                         preview window
function M.open_floating_preview(contents, syntax, opts)
  validate({
    contents = { contents, 't' },
    syntax = { syntax, 's', true },
    opts = { opts, 't', true },
  })
  opts = opts or {}
  opts.wrap = opts.wrap ~= false -- wrapping by default
  opts.stylize_markdown = opts.stylize_markdown ~= false
  opts.close_events = opts.close_events or { 'CursorMoved', 'CursorMovedI', 'InsertCharPre' }

  local bufnr = api.nvim_get_current_buf()

  -- check if this popup is focusable and we need to focus
  if opts.focus_id and opts.focusable ~= false and opts.focus then
    -- Go back to previous window if we are in a focusable one
    local current_winnr = api.nvim_get_current_win()
    if npcall(api.nvim_win_get_var, current_winnr, opts.focus_id) then
      api.nvim_command('wincmd p')
      return bufnr, current_winnr
    end
    do
      local win = find_window_by_var(opts.focus_id, bufnr)
      if win and api.nvim_win_is_valid(win) and vim.fn.pumvisible() == 0 then
        -- focus and return the existing buf, win
        api.nvim_set_current_win(win)
        api.nvim_command('stopinsert')
        return api.nvim_win_get_buf(win), win
      end
    end
  end

  -- check if another floating preview already exists for this buffer
  -- and close it if needed
  local existing_float = npcall(api.nvim_buf_get_var, bufnr, 'lsp_floating_preview')
  if existing_float and api.nvim_win_is_valid(existing_float) then
    api.nvim_win_close(existing_float, true)
  end

  ---@type number
  local floating_bufnr = api.nvim_create_buf(false, true)
  ---@type boolean
  local do_stylize = string.find(syntax, 'markdown') ~= nil and opts.stylize_markdown
  ---@type string[]
  local syn_list = vim.split(syntax, '.', { plain = true, trimempty = true })

  local custom_syn = nil
  for _, syn in ipairs(syn_list) do
    if syn and #syn > 0 and syn ~= 'markdown' then
      custom_syn = syn
      break
    end
  end

  -- Clean up input: trim empty lines from the end, pad
  contents = M._trim(contents, opts)

  -- api.nvim_buf_set_option(floating_bufnr, 'filetype', syntax)
  if do_stylize then
    -- applies the syntax and sets the lines to the buffer
    contents = M.stylize_markdown(floating_bufnr, contents, opts)
  else
    if syntax then
      api.nvim_set_option_value('syntax', syntax, { buf = floating_bufnr })
    end
    api.nvim_buf_set_lines(floating_bufnr, 0, -1, true, contents)
  end
  if custom_syn then
    api.nvim_set_option_value('filetype', custom_syn, { buf = floating_bufnr })
  end

  -- Compute size of float needed to show (wrapped) lines
  if opts.wrap then
    opts.wrap_at = opts.wrap_at or api.nvim_win_get_width(0)
  else
    opts.wrap_at = nil
  end
  local width, height = M._make_floating_popup_size(contents, opts)

  local float_option = M.make_floating_popup_options(width, height, opts)
  local floating_winnr = api.nvim_open_win(floating_bufnr, false, float_option)
  if do_stylize then
    api.nvim_set_option_value('conceallevel', 2, { win = floating_winnr })
    api.nvim_set_option_value('concealcursor', 'n', { win = floating_winnr })
  end
  -- disable folding
  api.nvim_set_option_value('foldenable', false, { win = floating_winnr })
  -- soft wrapping
  api.nvim_set_option_value('wrap', opts.wrap, { win = floating_winnr })

  api.nvim_set_option_value('modifiable', false, { buf = floating_bufnr })
  api.nvim_set_option_value('bufhidden', 'wipe', { buf = floating_bufnr })
  api.nvim_buf_set_keymap(floating_bufnr, 'n', 'q', '<cmd>bdelete<cr>', {
    silent = true,
    noremap = true,
    nowait = true,
  })
  api.nvim_buf_set_keymap(floating_bufnr, 'n', '<esc>', '<cmd>bdelete<cr>', {
    silent = true,
    noremap = true,
    nowait = true,
  })

  -- I'd like to disable matchup
  api.nvim_buf_set_var(floating_bufnr, 'matchup_matchparen_enabled', 0)
  api.nvim_buf_set_var(floating_bufnr, 'matchup_matchparen_fallback', 0)

  if type(opts.callback) == 'function' then
    opts.callback(floating_bufnr, bufnr)
  end

  close_preview_autocmd(opts.close_events, floating_winnr, { floating_bufnr, bufnr })

  -- save focus_id
  if opts.focus_id then
    api.nvim_win_set_var(floating_winnr, opts.focus_id, bufnr)
  end
  api.nvim_buf_set_var(bufnr, 'lsp_floating_preview', floating_winnr)

  return floating_bufnr, floating_winnr
end

--- Previews a location in a floating window
---
--- behavior depends on type of location:
---   - for Location, range is shown (e.g., function definition)
---   - for LocationLink, targetRange is shown (e.g., body of function definition)
---
---@param location any    a single `Location` or `LocationLink`
---@return number, number (bufnr,winnr) buffer and window number of floating window or nil
function M.preview_location(location, opts)
  -- location may be LocationLink or Location (more useful for the former)
  local uri = location.targetUri or location.uri
  if uri == nil then
    return 0, 0
  end

  local bufnr = vim.uri_to_bufnr(uri)
  if not api.nvim_buf_is_loaded(bufnr) then
    vim.fn.bufload(bufnr)
  end
  local range = location.targetRange or location.range
  local contents = api.nvim_buf_get_lines(bufnr, range.start.line, range['end'].line + 1, false)
  local syntax = api.nvim_get_option_value('syntax', { buf = bufnr })
  if syntax == '' then
    -- When no syntax is set, we use filetype as fallback. This might not result
    -- in a valid syntax definition. See also ft detection in stylize_markdown.
    -- An empty syntax is more common now with TreeSitter, since TS disables syntax.
    syntax = api.nvim_get_option_value('filetype', { buf = bufnr })
  end
  opts = opts or {}
  opts.focus_id = 'location'
  return M.open_floating_preview(contents, syntax, opts)
end

---@param new_name string
---@return nil
function M.rename(new_name)
  local params = vim.lsp.util.make_position_params()
  local opts = {
    prompt = 'New Name: ',
  }

  ---@private
  local function on_confirm(input)
    if not (input and #input > 0) then
      return
    end
    params.newName = input
    request('textDocument/rename', params)
  end

  ---@private
  local function prepare_rename(err, result)
    if err == nil and result == nil then
      vim.notify('nothing to rename', vim.log.levels.INFO)
      return
    end
    if result and result.placeholder then
      opts.default = result.placeholder
      if not new_name then
        npcall(vim.ui.input, opts, on_confirm)
      end
    elseif
      result
      and result.start
      and result['end']
      and result.start.line == result['end'].line
    then
      ---@type string
      local line = vim.fn.getline(result.start.line + 1)
      local start_char = result.start.character + 1
      local end_char = result['end'].character
      opts.default = string.sub(line, start_char, end_char)
      if not new_name then
        npcall(vim.ui.input, opts, on_confirm)
      end
    else
      -- XXX(@solarizedalias):
      -- This fallback doesn't work if the server never even responds to 'textDocument/prepareRename'.

      -- fallback to guessing symbol using <cword>
      --
      -- this can happen if the language server does not support prepareRename,
      -- returns an unexpected response, or requests for "default behavior"
      --
      -- see https://microsoft.github.io/language-server-protocol/specification#textDocument_prepareRename
      opts.default = vim.fn.expand('<cword>')
      if not new_name then
        npcall(vim.ui.input, opts, on_confirm)
      end
    end
    if new_name then
      on_confirm(new_name)
    end
  end

  --@solarizedalias OG
  -- request('textDocument/prepareRename', params, prepare_rename)

  --@solarizedalias BG

  -- Wait for the response (<=250ms) instead of sending an async request with the handler.
  local res = request_sync('textDocument/prepareRename', params, 250)
  if res then
    if type(res[1]) == 'table' and vim.tbl_isempty(res[1]) then
      res[1] = nil
    end
    return prepare_rename(nil, res[1])
  end

  -- Fallback to the old method (see neovim/neovim#15514)
  -- new_name = new_name or npcall(vim.fn.input, "New Name: ", vim.fn.expand('<cword>'))
  -- on_confirm(new_name)

  opts.default = vim.fn.expand('<cword>')
  if not new_name then
    npcall(vim.ui.input, opts, on_confirm)
  end
end

return M
