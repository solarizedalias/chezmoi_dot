local vd = vim.diagnostic
local vds = vim.diagnostic.severity

---@param group   string
---@param text    string
---@param texthl? string
local function sign_define(group, text, texthl)
  vim.validate({
    group = { group, 'string' },
    text = { text, 'string' },
    texthl = { texthl, 'string', true },
  })
  texthl = texthl or group
  vim.cmd(string.format('sign define %s text=%s texthl=%s', group, text, texthl))
end

---@type fun(n: number): string
local nr2char = vim.fn.nr2char

local signs = {
  [vds.ERROR] = nr2char(0xf05e),
  [vds.WARN] = nr2char(0xf071),
  [vds.INFO] = nr2char(0xf129),
  [vds.HINT] = nr2char(0xf0f3),
}

vd.config({
  virtual_text = { source = true },
  float = {
    source = true,
    focusable = false,
    border = 'single',
    prefix = function(diagnostic, _, _)
      local icon, highlight
      if diagnostic.severity == vds.ERROR then
        icon = '󰅙'
        highlight = 'DiagnosticError'
      elseif diagnostic.severity == vds.WARN then
        icon = ''
        highlight = 'DiagnosticWarn'
      elseif diagnostic.severity == vds.INFO then
        icon = ''
        highlight = 'DiagnosticInfo'
      elseif diagnostic.severity == vds.HINT then
        icon = ''
        highlight = 'DiagnosticHint'
      end
      return icon .. ' ', highlight
    end,
  },
  severity_sort = true,
  signs = {
    linehl = {
      [vds.ERROR] = 'DiagnosticsSignError',
      [vds.WARN] = 'DiagnosticsSignWarn',
      [vds.INFO] = 'DiagnosticsSignInfo',
      [vds.HINT] = 'DiagnosticsSignHint',
    },
    numhl = {
      [vds.ERROR] = 'DiagnosticsSignError',
      [vds.WARN] = 'DiagnosticsSignWarn',
      [vds.INFO] = 'DiagnosticsSignInfo',
      [vds.HINT] = 'DiagnosticsSignHint',
    },
    text = signs,
    priority = 10, -- default
  },
})

-- sign_define('DiagnosticSignError', signs[vds.ERROR])
-- sign_define('DiagnosticSignWarn', signs[vds.WARN])
-- sign_define('DiagnosticSignInfo', signs[vds.INFO])
-- sign_define('DiagnosticSignHint', signs[vds.HINT])

-- XXX passing lua function as rhs causes which-key to break
-- vim.keymap.set('n', '<leader>dn', function()
--   vim.diagnostic.goto_next({ float = { border = 'single' } })
-- end, {})
-- vim.keymap.set('n', '<leader>dp', function()
--   vim.diagnostic.goto_prev({ float = { border = 'single' } })
-- end, {})
vim.keymap.set(
  'n',
  '<leader>dn',
  [[<cmd>lua vim.diagnostic.goto_next({ float = { border = 'single' } })<cr>]],
  {}
)
vim.keymap.set(
  'n',
  '<leader>dp',
  [[<cmd>lua vim.diagnostic.goto_prev({ float = { border = 'single' } })<cr>]],
  {}
)
