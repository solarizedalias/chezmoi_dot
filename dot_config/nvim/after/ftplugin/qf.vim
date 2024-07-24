
lua require('myqf')

nnoremap <buffer> q     <cmd>q<cr>
nnoremap <buffer> <tab> <cr>zz<cmd>silent! foldopen!<cr><c-w>p

nnoremap <buffer> dd    <cmd>lua require('myqf').delete()<cr>
nnoremap <buffer> <c-n> <cmd>lua require('myqf').select_move('j')<cr>
nnoremap <buffer> <c-p> <cmd>lua require('myqf').select_move('k')<cr>

