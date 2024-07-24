
" finish

if exists('b:did_filetype')
  finish
endif
let b:did_filetype = 1

augroup ShellspecSyntaxBefore
  autocmd!
  autocmd BufNewFile,BufRead */spec/*.sh  set filetype=sh.shellspec "" \| runtime syntax/after/shellspec.vim
  autocmd BufNewFile,BufRead */spec/*.zsh set filetype=zsh.shellspec "" \| runtime syntax/after/shellspec.vim
augroup END

