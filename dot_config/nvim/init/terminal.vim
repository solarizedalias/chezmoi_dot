
function! s:save_terminal_mode() abort
  let b:terminal_mode = mode()
endfunction

function! s:restore_terminal_mode() abort
  if get(b:, 'terminal_mode', '') ==# 't'
    startinsert
  endif
endfunction
augroup init_terminal
  autocmd!
  if has('nvim')
    autocmd TermOpen  term://* startinsert
    autocmd TermEnter term://* call s:save_terminal_mode()
    autocmd TermLeave term://* call s:save_terminal_mode()
    autocmd BufEnter  term://* call s:restore_terminal_mode()
  endif
augroup END

" maps
if has('nvim')
  " emulate OG Vim binding in Neo.
  tnoremap <c-w>n     <c-\><c-n>
  tnoremap <c-w><c-n> <c-\><c-n>
  tnoremap <c-w>.     <c-w>
  tnoremap <c-w><c-w> <cmd>wincmd w<cr>
endif

