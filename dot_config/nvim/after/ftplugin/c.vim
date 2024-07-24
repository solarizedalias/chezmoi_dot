
let s:prompt = 'header >> '

function! s:gen_include() abort
  let l:inputs = []
  let l:input = input(s:prompt)
  while len(l:input) > 0
    call add(l:inputs, l:input)
    let l:input = input(s:prompt)
  endwhile
  return map(l:inputs, {_, val -> printf('#include <%s>', val)})
endfunction

function! s:insert_gen_include() abort
  call append(line('.'), s:gen_include())
endfunction

command! -nargs=0 GenInclude silent call <sid>insert_gen_include()

