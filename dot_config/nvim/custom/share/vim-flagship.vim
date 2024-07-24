
scriptencoding utf-8

let g:tabprefix = '∆'
let g:tablabel =
      \ '%{flagship#tabbufnr()}' .
      \ '%{flagship#tabmodified()} ' .
      \ "%{flagship#tabcwds('shorten',',')}/" .
      \ '%{CustomFname(flagship#tabbufnr())}'

function! CustomFname(nr) abort
  let l:bname = bufname(a:nr)
  let l:path = fnamemodify(l:bname, ':p:h')
  let l:result = fnamemodify(l:bname, ':t')

  if l:path !=# expand(flagship#cwd())
    let l:result = '.../' . l:result
  endif
  return l:result
endfunction

