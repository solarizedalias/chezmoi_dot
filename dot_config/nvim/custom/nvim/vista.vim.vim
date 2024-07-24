scriptencoding utf-8

if !has('nvim')
  finish
endif

" OPTIONS
let g:vista_sidebar_position = 'vertical topleft'
let g:vista#renderer#enable_icon = 1
let g:vista_fzf_preview = ['right:50%']
let g:vista_icon_indent = ['╰─▸ ', '├─▸ ']

" MAPS
nnoremap <leader>vi <cmd>Vista!!<cr>
nnoremap <leader>vf <cmd>Vista finder<cr>

