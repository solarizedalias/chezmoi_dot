
lua require('custom/nvim-treesitter/all_in')

function! TSCustomLightlineForceUpdate() abort
  execute 'normal! :TSBufEnable ' . "\<tab>\<tab>\<tab>\<c-w>\<tab>\<c-c>"
endfunction

execute "nnoremap <buffer> <leader>\\ :TSBufEnable \<space> \<tab>\<tab>\<tab>\<c-w>\<c-c>"

augroup Custom_nvim_treesitter
  autocmd!
  " autocmd BufRead,BufNewFile *.sh    lua require('nvim-treesitter.configs').attach_module('highlight')
  " autocmd FileType c,cpp,sh,toml,json,jsonc,yaml,javascript,typescript,lua,rust,cs,zig
  "       \ setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()

  " autocmd FileType zsh lua require('custom/nvim-treesitter/diminished')
  " autocmd BufReadPre,BufNewFile */.dein/*.toml lua require('custom/nvim-treesitter/diminished')

augroup END

