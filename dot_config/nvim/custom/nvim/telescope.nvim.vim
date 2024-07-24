
if !has('nvim')
  finish
endif

nnoremap <leader><leader><leader> <cmd>Telescope<cr>
nnoremap <leader>M                <cmd>Telescope man_pages<cr>
nnoremap <leader>o                <cmd>lua require('telescope').extensions.frecency.frecency({ sorter = require('telescope.config').values.generic_sorter() })<cr>
nnoremap <leader>gS               <cmd>Telescope lsp_document_symbols<cr>

augroup nvim_dein_telescope
  autocmd!
  " XXX Not so accurate, but better than nothing. Wait, how does i_ctrl-w
  " fails for TelescopePrompt in the first place?
  autocmd FileType TelescopePrompt inoremap <buffer> <c-w> <esc>bdwa
augroup END

