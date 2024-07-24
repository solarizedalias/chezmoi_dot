if !has('nvim')
  finish
endif

let g:precious_enable_switch_CursorMoved = {
\   '*': 0
\}
let g:precious_enable_switch_CursorMoved_i = {
\   '*': 0
\}
let g:precious_enable_switch_CursorHold = {
\   '*': 0
\}

let g:precious_enable_switchers = {
\   'vim': {
\     'setfiletype': 0
\   }
\}

" augroup PreciousSwitch
"   autocmd!
"   " autocmd InsertEnter * PreciousSwitch
"   " autocmd InsertLeave * PreciousReset

"   autocmd CursorHold * if wait(500, 0, 250) == -1 &&
"         \ precious#context_filetype() !=# precious#base_filetype()
"         \  | :PreciousSwitch | else | :PreciousReset | endif

"   autocmd User PreciousFileType echo precious#context_filetype()
"   autocmd User PreciousFileType let &l:syntax = precious#context_filetype()
" augroup END

