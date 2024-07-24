finish

" if exists('b:did_filetype')
"   finish
" endif

" let b:did_filetype = 1

" augroup ShellspecSyntaxAfter
"   autocmd!
"   autocmd FileType * if &syntax =~# 'zsh' && expand('%') =~# '.*/spec/.*' | setlocal filetype=zsh.shellspec | endif
"   autocmd FileType * if &syntax =~# 'sh' && &syntax !~# 'zsh' && expand('%') =~# '.*/spec/.*' | setlocal filetype=sh.shellspec  | endif
" augroup END

