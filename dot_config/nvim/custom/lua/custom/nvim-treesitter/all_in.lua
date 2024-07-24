local base = require('custom/nvim-treesitter/base_config')

local config = vim.deepcopy(base)
require('nvim-treesitter.configs').setup(config)
