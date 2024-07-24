local M = {
  ensure_installed = 'all',
  highlight = {
    enable = true,
    -- additional_vim_regex_highlighting = {
    --   'lua',
    -- },
  },
  indent = { enable = true },
  refactor = {
    highlight_definition = { enable = true },
    highlight_current_scope = { enable = false },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = 'grr',
      },
    },
    navigation = {
      enable = true,
    },
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['aC'] = '@class.outer',
        ['iC'] = '@class.inner',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
    move = {
      enable = true,
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<localleader><localleader>',
      node_incremental = '.',
      node_decremental = ',',
      scope_incremental = ';',
    },
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false,
  },
  matchup = {
    enable = true,
    disable_virtual_text = { 'nim' },
    include_match_words = true,
  },
}

return M
