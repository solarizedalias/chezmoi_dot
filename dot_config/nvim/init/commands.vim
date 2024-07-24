
if exists('g:done_init_commands')
  finish
endif

" =========================== COMMANDS =============================

if !has('nvim')

  " highlight Terminal ctermbg=NONE guibg=NONE
  command! TTYpop
    \ call popup_create(
    \   term_start([&shell, '-l'], {'hidden': 1, 'term_finish': 'close'},
    \     {'border': [], 'minwidth': winwidth(0) / 2, 'minheight': &lines / 2})

  command! TTYvert vert term ++close zsh -l
  command! TTYhr rightbelow term ++close zsh -l
endif

command! -nargs=0 Vimrc edit ~/.config/nvim/init.vim
command! -nargs=0 Ovimrc edit ~/.vimrc

" I can definitely inline this function but I didn't for the sake of
" highlighting.
function! s:print_rtp() abort
  echo join(split(&runtimepath, ','), "\n")
endfunction
command! -nargs=0 Runtimepath call s:print_rtp()

command! BracketVar %s/\v\$(%(|[+=^])[[:alnum:]_]+%(\[.*\]|:[a-zA-Z&])*)/${\1}/gec
command! CaseLParen %s/\v^\s*\zs([^( ]+[)])/(\1)/gec

" set runtimepath+=~/.vim/bundles/repos/github.com/vim-jp/vimdoc-ja
command! HelpEng set helplang=en
command! HelpJa  set helplang=ja

command! Dashy silent execute '!open -g dash://' . &ft . ":\<cword>"
nnoremap <leader><leader>d :Dashy<cr>

let g:done_init_commands = 1

command! -bang -nargs=1 -complete=file RO view<bang> +set\ nomodifiable <args>

