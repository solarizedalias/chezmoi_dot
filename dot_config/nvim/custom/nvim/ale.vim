scriptencoding utf-8

let g:ale_lua_stylua_options = '--search-parent-directories'

let g:ale_echo_cursor = 0
let g:ale_use_neovim_diagnostics_api = 1
" this is probably no longer needed thanks to g:ale_use_neovim_diagnostics_api
" lua require('custom/ale').setup()

" if has('nvim')
"   let g:ale_detail_to_floating_preview = 1
"   " let g:ale_virtualtext_cursor = 1
"   " let g:ale_virtualtext_prefix = '[ALE] '
"   " let g:ale_cursor_detail = 1
"   " let g:ale_echo_cursor = 0
"   let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']
" endif

