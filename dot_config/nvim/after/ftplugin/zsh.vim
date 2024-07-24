
setlocal foldmethod=indent

let b:dispatch = 'zsh -n %'
command! -buffer -nargs=* Zcompile execute '!zcompile -Uz ' . <q-args> . ' ' . expand('%:p')
command! -buffer -nargs=* Zcpd     execute '!zcompile-digest -fv ' . expand('%:p:h')
command! -buffer -nargs=* Run      execute '!' . expand('%:p') . ' ' . <q-args>
command! -buffer -nargs=1 Chmod    execute '!chmod ' . <q-args> . ' ' . expand('%:p')

command! -buffer BracketVar %s/\v\$([+=^~]*[#]*[[:alnum:]_]+%(\[.{-1,}[\\]@<!\])*%(:[a-zA-Z&])*)/${\1}/gec
command! -buffer CaseLParen %s/\v^\s*\zs([^( ]+[)])/(\1/gec
command! -buffer AndAndToIf
      \ %sm/^\(\s*\)\((([^&|]\{-}))\|[\[]\{1,2}[^&|]\{-}[\]]\{1,2}\)\s*&&\(.*\)/\1if \2; then\r\1 \3\r\1fi/gec
command! -buffer OrOrToIf
      \ %sm/^\(\s*\)\((([^&|]\{-}))\|[\[]\{1,2}[^&|]\{-}[\]]\{1,2}\)\s*||\(.*\)/\1if ! \2; then\r\1 \3\r\1fi/gec

setlocal dictionary+=~/.vim/words/zsh.txt
setlocal foldmethod=indent

" ******************************** TEXTOBJ *********************************
" [[[1
function! s:check_unmatched(line) abort
  let l:pairs = { '{':'}', '(':')', '"':'"', "'":"'", '`':'`' }
  let l:lhs = split(a:line[ : (col('.')-1)], '[&|;]\{1,2\}')[-1]
  let l:rhs = col('.') != col('$') -1 ? split(a:line[col('.') : ], '[&|;]\{1,2\}')[0] : ''
  let l:current_sentense = l:lhs . l:rhs
  for l:key in keys(l:pairs)
    if count(l:current_sentense, l:key) != count(l:current_sentense, l:pairs[l:key]) | return 1 | endif
  endfor
  return 0
endfunction

function! ZshSentenceA()
  let l:line_no = line('.')
  let l:line = getline('.')
  let l:col = col('.') -1
  " Exclude anything valid as one line but not a sentense alone.
  if l:line =~?
        \ '^\s*\%(while\|for\|until\|select\|do\|done\|break\|continue\|\%(case\s*\${\=\S\+}\=\s*in\)\|esac\|if\|then\|elif\%(\s\+\)\=\|else\|fi\|[{}()\[\]]\{1,2\}\)\s*$'
        \ || l:line[(l:col)] =~# '\%([&|;]\)'
        \ || s:check_unmatched(l:line)
    return 0
  else
    " get the column of the first &,|,; after the cursor if any.
    " Becomes col('.') -1 if none (because match() returns -1 ).
    let l:r_del = match(l:line[(l:col + 1) : ], '\%([&|;]\{1,2\}\|$\)') + l:col + 1
    " If there exists, accept the value.
    " Use the column of the cursor otherwise.
    let l:tail_pos = l:r_del > l:col + 1 ? l:r_del : l:col + 1

    let l:head_pos = -1
    for l:idx in range(l:col, 0, -1)
      " check 2 chars if they match the delimiter pattern
      if l:line[l:idx-1 : (l:idx)] =~# '[&|;]\+'
        let l:head_pos = l:idx + 1
        break
      endif
    endfor
    if l:head_pos < 0
      let l:head_pos = match(l:line, '\S') + 1
    endif
  endif
  return ['v', [0, l:line_no, l:head_pos, 0], [0, l:line_no, l:tail_pos, 0]]
endfunction

function! ZshSentenceI()
  let l:line_no = line('.')
  let l:line = getline('.')
  let l:col = col('.') -1
  " Exclude anything valid as one line but not a sentense alone.
  if l:line =~?
        \ '^\s*\%(while\|for\|until\|select\|do\|done\|break\|continue\|\%(case\s*\${\=\S\+}\=\s*in\)\|esac\|if\|then\|elif\%(\s\+\)\=\|else\|fi\|[{}()\[\]]\{1,2\}\)\s*$'
        \ || l:line[(l:col)] =~# '\%([&|;]\)'
        \ || s:check_unmatched(l:line)
    return 0
  else
    " get the column of the first &,|,; after the cursor if any.
    " Becomes col('.') -1 if none (because match() returns -1 ).
    let l:r_del = match(l:line[(l:col + 1) : ], '\%([&|;]\{1,2\}\|$\)') + l:col + 1
    " If there exists, accept the value.
    " Use the column of the cursor otherwise.
    let l:tail_pos = l:r_del > l:col + 1 ? l:r_del : l:col + 1

    let l:head_pos = -1
    for l:idx in range(l:col, 0, -1)
      if l:line[l:idx-1 : (l:idx)] =~# '[&|;]\+'
        let l:head_pos = l:idx + 1
        break
      endif
    endfor
    if l:head_pos < 0
      let l:head_pos = match(l:line, '\S') + 1
    endif
  endif

  for l:c in range(l:head_pos-1, col('$') -1)
    if l:line[l:c-1] =~# '[\s|;&]'
      continue
    else
      let l:head_pos = l:c +1
      break
    endif
  endfor
  for l:c in range(l:tail_pos, l:col, -1)
    if l:line[l:c-1] =~# '\s'
      continue
    else
      let l:tail_pos = l:c
      break
    endif
  endfor
  return ['v', [0, l:line_no, l:head_pos, 0], [0, l:line_no, l:tail_pos, 0]]
endfunction

call textobj#user#plugin('grammer', {
      \   'sentence': {
      \     'select-a-function': 'ZshSentenceA',
      \     'select-a': 'aS',
      \     'select-i-function': 'ZshSentenceI',
      \     'select-i': 'iS',
      \   }
      \ })

" 1]]]
" ***************************************************************************

