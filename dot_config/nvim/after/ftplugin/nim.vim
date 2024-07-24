
command! -nargs=? DashNim silent call <sid>dash_nim(<q-args>)

function! s:dash_nim(...) abort
  if (a:0 < 1 || a:1 =~# '^\s*$') && expand("\<cword>") !=# ''
    execute "!open -g dash://nim:\<cword>"
  elseif a:1 =~# '^\S\+$'
    execute '!open -g dash://nim:' . a:1
  endif
endfunction

" setlocal foldmethod=expr
" setlocal foldexpr=nvim_treesitter#foldexpr()

