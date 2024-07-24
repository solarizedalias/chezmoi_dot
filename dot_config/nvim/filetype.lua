--# lua <<EOS
--#   require('filetype').setup({
--#     overrides = {
--#       extensions = {
--#         nims = 'nim',
--#         nimble = 'nim',
--#         snip = 'neosnippet',
--#       },
--#       literal = {
--#         ['.gitignore'] = 'gitignore',
--#         [vim.fn.stdpath('config') .. '/git/ignore'] = 'gitignore',
--#       },
--#       complex = {
--#         ['.*/.git/info/exclude'] = 'gitignore',
--#       },
--#     },
--#   })
--# EOS

vim.filetype.add({
  extension = { nims = 'nim', nimble = 'nim' },
  filename = { [vim.fn.stdpath('config') .. '/git/ignore'] = 'gitignore' },
  pattern = { ['.*/%.git/info/exclude'] = 'gitignore' },
})
