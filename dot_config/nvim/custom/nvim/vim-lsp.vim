
if !has('nvim') || exists('g:did_custom_vim_lsp')
  finish
endif

let s:custom = expand('~/.vim/custom/vim-lsp')
let s:shares = globpath(s:custom, '/*/share.vim', 0, 1)
let s:nvims = globpath(s:custom, '/*/nvim.vim', 0, 1)

for s:sf in s:shares
  execute 'source ' . s:sf
endfor

for s:nf in s:nvims
  execute 'source ' . s:nf
endfor

let g:did_custom_vim_lsp = 1

