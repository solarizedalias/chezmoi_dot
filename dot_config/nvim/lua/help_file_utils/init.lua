local M = {}

-- TODO?
if false then
  local function concealed_len(buf, lnum)
    assert(lnum > 0, 'invalid line number: ' .. tostring(lnum))
    local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, true)[1]
    local subtract = 0
    for i = 0, #line do
      if vim.fn.synconcealed(lnum, i)[0] ~= 0 then
        subtract = subtract + 1
      end
    end

    return #line - subtract
  end
end

local function align_tagged_line(line)
  local tokens = vim.fn.split(line, [[\s\s\+\zs]])
  if #tokens ~= 2 then
    return line
  end
  local olen = #line
  local nspaces = 82 - olen
  return tokens[1] .. string.rep(' ', nspaces) .. tokens[2]
end

local function align_tagged(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)
  local pat = vim.regex([[\s\s\+\*[^*]\+\*$]])
  lines = vim.tbl_map(function(line)
    if pat:match_str(line) then
      return align_tagged_line(line)
    end
    return line
  end, lines)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)
end

vim.api.nvim_add_user_command('AlignTagged', function()
  align_tagged(vim.api.nvim_get_current_buf())
end, {})

return M
