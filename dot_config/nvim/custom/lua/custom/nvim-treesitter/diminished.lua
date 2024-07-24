local base = require('custom/nvim-treesitter/base_config')

local config = vim.deepcopy(base)
config.highlight.disable = {
  'bash',
  'vim',
  'zsh',
  'shellspec',
  'toml',
  'markdown',
}
config.refactor.highlight_definition.disable = {
  'zsh',
  'shellspec',
}
config.refactor.highlight_current_scope.disable = {
  'bash',
  'zsh',
  'shellspec',
  'toml',
  'markdown',
}
require('nvim-treesitter.configs').setup(config)
