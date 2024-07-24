-- XXX NOT WORKING

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.nim = {
  install_info = {
    url = '~/solarizedalias/github.com/haxscramper/tree-sitter-nim',
    files = { 'src/parser.c' },
  },
  filetype = 'nim',
}
