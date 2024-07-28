-- TODO Load workspace local config files

-- print(vim.inspect(debug.getinfo(1).source:match("@?(.*/)")))

local log = require('vim.lsp.log')
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
local overrides = require('custom/nvim-lspconfig/overrides')

local M = {}

function M.custom_hover()
  -- depends on  ~/.vim/lua/my_maps/close_float_wins.lua
  require('my_maps/close_float_wins')()
  return vim.lsp.buf.hover()
end

---@param result table
---@param config table
---@param syntax string
---@return number, number
local function hover_base(_, result, _, config, syntax)
  config = config or {}
  config.focus_id = 'textDocument/hover'
  if not (result and result.contents) then
    vim.notify('No information avaiable', vim.log.levels.WARN, { title = config.focus_id })
    return 0, 0
  end
  ---@type string[]
  local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)

  -- markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
  markdown_lines = vim.split(vim.iter(markdown_lines):join('\n'), '\n', { trimempty = true })
  if vim.tbl_isempty(markdown_lines) then
    vim.notify('failed to convert output to markdown lines', vim.log.levels.WARN, {
      title = config.focus_id,
    })
    return 0, 0
  end
  local bufnr, winnr = overrides.open_floating_preview(markdown_lines, syntax, config)
  vim.api.nvim_set_option_value('signcolumn', 'no', { win = winnr })
  vim.g.lsp_hover_bufnr = bufnr
  vim.g.lsp_hover_winnr = winnr
  return bufnr, winnr
end

---@param result table
---@param config table
local function hover_default(_, result, ctx, config)
  return hover_base(_, result, ctx, config, 'markdown')
end

local function preview_location_callback(_, result)
  -- print(vim.inspect(result))
  -- print(vim.inspect(result[1]))

  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  return vim.lsp.util.preview_location(result[1], { border = 'single', close_events = {} })
end
function M.peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

---Use your favorite split method for goto_definition.
---If the location is found in the current tabpage, jump to there
---without opening a new window
---@param split_cmd? string
local function goto_def_handler(split_cmd)
  local handler = function(_, result, ctx, _)
    local method = ctx.method
    if result == nil or vim.tbl_isempty(result) then
      local _ = log.info and log.info(method, 'No location found')
      return nil
    end

    local uri
    if vim.islist(result) then
      ---@type string
      uri = result[1].uri or result[1].targetUri
    else
      ---@type string
      uri = result.uri or result.targetUri
    end

    if uri == nil then
      log.error(method, 'Invalid response from server')
    end

    ---@type integer
    local bufnr = vim.uri_to_bufnr(tostring(uri))

    if vim.fn.bufnr() ~= bufnr then
      local tab_wins = vim.tbl_filter(vim.api.nvim_win_is_valid, vim.api.nvim_tabpage_list_wins(0))
      local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
      local found = false
      for i, v in ipairs(tab_bufs) do
        if v == bufnr then
          found = true
          vim.api.nvim_set_current_win(tab_wins[i])
          break
        end
      end
      if not found and split_cmd then
        vim.cmd(split_cmd)
      end
    end

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    assert(client ~= nil)
    if vim.islist(result) then
      vim.lsp.util.jump_to_location(result[1], client.offset_encoding)

      if #result > 1 then
        vim.fn.setqflist(vim.lsp.util.locations_to_items(result, client.offset_encoding))
        vim.api.nvim_command('botright copen')
        vim.api.nvim_command('wincmd p')
      end
    else
      vim.lsp.util.jump_to_location(result, client.offset_encoding)
    end
  end

  return handler
end

---@param split_cmd? string
function M.goto_def_with_split(split_cmd)
  local old_handler = vim.lsp.handlers['textDocument/definition']
  vim.lsp.handlers['textDocument/definition'] = goto_def_handler(split_cmd)
  vim.lsp.buf.definition()
  vim.lsp.handlers['textDocument/definition'] = old_handler
end

---@param mode string
---@param lhs string
---@param action string|function
local function map(mode, lhs, action)
  vim.keymap.set(mode, lhs, action, { buffer = 0, silent = true, noremap = true })
end

do
  -- Default config
  vim.lsp.handlers['textDocument/hover'] =
    vim.lsp.with(hover_default, { border = 'single', close_events = {} })
  vim.lsp.handlers['textDocument/signatureHelp'] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single', close_events = {} })

  vim.lsp.handlers['textDocument/definition'] = goto_def_handler('botright vsplit')
end

local custom_attach = function()
  map('n', 'K', M.custom_hover)
  -- no argument to goto_def_with_split means switch to the buffer without splitting
  map('n', '<leader>gD', M.goto_def_with_split)

  map('n', '<leader>gd', vim.lsp.buf.definition)
  map('n', '<leader>gt', vim.lsp.buf.type_definition)
  map('n', '<leader>gr', vim.lsp.buf.references)
  map('n', '<leader>gs', vim.lsp.buf.document_symbol)
  map('n', '<leader>rn', M.rename)
  -- mapper('n', '<leader>gp', 'require("custom/nvim-lspconfig").peek_definition()')

  map('n', '<leader>gg', vim.lsp.buf.signature_help)
  map('i', '<c-x><c-x>', vim.lsp.buf.signature_help)
end

-- global maps
vim.keymap.set('n', '<leader>eL', '<cmd>LspRestart<cr>', {})

-- For some languages, ALE provides duplicated/better diagnostics.
local function has_ale(buf)
  vim.validate({ buf = { buf, 'number' } })
  local bufnr_s = tostring(buf)
  local ale_buf_info = vim.g.ale_buffer_info
  return not not (ale_buf_info and ale_buf_info[bufnr_s])
end
local prefer_ale = {
  nimls = true,
  nim_langserver = true,
}

---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.handlers['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
  local server_name = vim.lsp.get_client_by_id(ctx.client_id).name
  if prefer_ale[server_name] and has_ale(ctx.bufnr or vim.fn.bufnr()) then
    return
  end
  vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
end

-- disable semantic highlight for comments because I always prefer treesitter
vim.api.nvim_set_hl(0, '@lsp.type.comment', {})

-- setup hook
do
  vim.g.auto_start_lsp = true
  if os.getenv('NVIM_AUTO_START_LSP') == '0' then
    vim.g.auto_start_lsp = false
  end
  lspconfig.util.on_setup = lspconfig.util.add_hook_after(lspconfig.util.on_setup, function(config)
    -- override it only when it's false
    if not vim.g.auto_start_lsp then
      config.autostart = false
    end
  end)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_ddc_source_lsp, ddc_source_lsp = pcall(require, 'ddc_source_lsp')
if has_ddc_source_lsp then
  capabilities = ddc_source_lsp.make_client_capabilities()
end

--
-- Severs
--

if false then
  local nim_attach = function()
    custom_attach()
    local function hover_nim(_, result, ctx, config)
      return hover_base(_, result, ctx, config, 'markdown.nimlsp-hover')
    end
    vim.lsp.handlers['textDocument/hover'] =
      vim.lsp.with(hover_nim, { border = 'single', close_events = {} })
  end
  lspconfig.nimls.setup({ on_attach = nim_attach })
end

if true then
  local nim_attach = function()
    custom_attach()
    local function hover_nim(_, result, ctx, config)
      return hover_base(_, result, ctx, config, 'markdown.nimlsp-hover')
    end
    vim.lsp.handlers['textDocument/hover'] =
      vim.lsp.with(hover_nim, { border = 'single', close_events = {} })
  end

  lspconfig.nim_langserver.setup({
    on_attach = nim_attach,
    settings = {
      nim = {
        nimsuggestPath = '~/.local/bin/nimsuggest',
        -- TODO: project local settings
      },
    },
  })
end

lspconfig.clangd.setup({
  on_attach = custom_attach,
  capabilities = capabilities,
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
    '--header-insertion=iwyu',
    '--header-insertion-decorators',
    '--completion-style=detailed',
  },
})

-- TODO: A lot has changed since the last time I checked the lspconfig doc.
--       We should probably adapt to the latest situation. (2023-08-11)
if false then
  local sumneko_root_path = vim.fn.stdpath('cache') .. '/lspconfig/sumneko_lua/lua-language-server'
  local sumneko_binary = sumneko_root_path .. '/bin/' .. 'lua-language-server'

  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  local function match_any(s, pats)
    for _, v in ipairs(pats) do
      if string.match(s, v) then
        return true
      end
    end
    return false
  end

  ---@type string[]
  local libraries = vim.api.nvim_list_runtime_paths()
  -- Remove huge and not useful directories.
  libraries = vim.tbl_filter(function(it)
    local home = vim.env['HOME']
    return not match_any(it, {
      home .. '/%.config/nvim',
      '.*/bundles/.cache/.*',
    })
  end, libraries)

  configs.sumneko_lua = {
    default_config = {
      cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
      filetypes = { 'lua' },
      runOutputDirectory = 'bin',
      root_dir = function(fname)
        return lspconfig.util.find_git_ancestor(fname) or lspconfig.util.path.dirname(fname)
      end,
      log_level = vim.lsp.protocol.MessageType.Warning,
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            -- Setup your lua path
            path = runtime_path,
          },
          diagnostics = {
            globals = { 'vim', 'describe' },
          },
          format = {
            enable = true,
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = libraries,
            -- Don't complain about files under these directories.
            ignoreDir = {
              '**/vim-persisted-undo/**',
              '**/.config/nvim/bundles',
              '**/.vim/bundles',
              '**/mackup/**',
            },
            checkThirdParty = false,
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = { enable = false },
        },
      },
    },
  }
  lspconfig.sumneko_lua.setup({ on_attach = custom_attach, capabilities = capabilities })
else
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  local function match_any(s, pats)
    for _, v in ipairs(pats) do
      if string.match(s, v) then
        return true
      end
    end
    return false
  end

  ---@type string[]
  local libraries = vim.api.nvim_list_runtime_paths()
  -- Remove huge and not useful directories.
  libraries = vim.tbl_filter(function(it)
    local home = vim.env['HOME']
    return not match_any(it, {
      home .. '/%.config/nvim',
      '.*/bundles/.cache/.*',
    })
  end, libraries)

  lspconfig.lua_ls.setup({
    on_init = function(client)
      local path = client.workspace_folders[1].name
      if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
        return
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using
          -- (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            libraries,
            -- Depending on the usage, you might want to add additional paths here.
            -- "${3rd}/luv/library"
            -- "${3rd}/busted/library",
          },
          -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
          -- library = vim.api.nvim_get_runtime_file("", true)
        },
      })
    end,
    on_attach = custom_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          globals = { 'vim', 'describe' },
        },
        format = {
          enable = true,
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = libraries,
          -- Don't complain about files under these directories.
          ignoreDir = {
            '**/vim-persisted-undo/**',
            '**/.config/nvim/bundles',
            '**/.vim/bundles',
          },
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = { enable = false },
      },
    },
  })
end

lspconfig.jsonls.setup({
  on_attach = custom_attach,
  capabilities = capabilities,
  settings = {
    json = {
      schemas = vim.list_extend(
        {
          {
            description = 'configulation file for lua-language-server',
            fileMatch = { '.luarc.json', '.luarc.jsonc' },
            name = '.luarc.json',
            url = 'https://raw.githubusercontent.com/sumneko/vscode-lua/master/setting/schema.json',
          },
        },
        -- b0o/SchemaStore.nvim
        require('schemastore').json.schemas()
      ),
      validate = { enable = true },
    },
  },
})

lspconfig.vimls.setup({
  on_attach = custom_attach,
  capabilities = capabilities,
  settings = {
    init_options = { isNeovim = true },
  },
})

lspconfig.prosemd_lsp.setup({ on_attach = custom_attach, capabilities = capabilities })
-- lspconfig.tsserver.setup({ on_attach = custom_attach, capabilities = capabilities })
lspconfig.denols.setup({ on_attach = custom_attach, capabilities = capabilities })
lspconfig.pylsp.setup({ on_attach = custom_attach, capabilities = capabilities })
lspconfig.dockerls.setup({ on_attach = custom_attach, capabilities = capabilities })
lspconfig.solargraph.setup({ on_attach = custom_attach, capabilities = capabilities })
lspconfig.yamlls.setup({ on_attach = custom_attach, capabilities = capabilities })
lspconfig.rust_analyzer.setup({ on_attach = custom_attach, capabilities = capabilities })
lspconfig.cmake.setup({ on_attach = custom_attach, capabilities = capabilities })
lspconfig.bashls.setup({
  on_attach = function()
    custom_attach()
    local function hover_bashls(_, result, ctx, config)
      return hover_base(_, result, ctx, config, 'markdown.man')
    end
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(hover_bashls, {
      border = 'single',
      close_events = {},
    })
  end,
  capabilities = capabilities,
})
lspconfig.efm.setup({
  on_attach = custom_attach,
  capabilities = capabilities,
  filetypes = { 'markdown' },
})
lspconfig.csharp_ls.setup({ on_attach = custom_attach, capabilities = capabilities })
lspconfig.zls.setup({
  on_attach = custom_attach,
  capabilities = capabilities,
  settings = {
    zls = {
      -- zig_exe_path = '/usr/local/bin/zig',
    },
  },
})

M.rename = overrides.rename

return M
