
scriptencoding utf-8
if exists('g:done_init_misc')
  finish
endif
let g:done_init_misc = 1

let g:init_d['autocmds'] = g:init_d['root'] . '/autocmds.vim'
let g:init_d['highlights'] = g:init_d['root'] . '/highlights.vim'
call Load_Init('autocmds')
call Load_Init('highlights')

let g:jellybeans_overrides = {
\   'background': { 'ctermbg': 'none', '256ctermbg': 'none' },
\ }
if has('termguicolors') && &termguicolors
    let g:jellybeans_overrides['background']['guibg'] = 'none'
endif

" ============================= vim-javascript =============================
let g:javascript_plugin_jsdoc = 1

" ============================== vim-markdown ===============================
let g:vim_markdown_fenced_languages = [
      \ 'zsh=zsh',
      \]
" let g:vim_markdown_folding_level = 3
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_syntax_conceal = 1
augroup init_vim_markdown
  autocmd!
  " autocmd FileType markdown setlocal conceallevel=0
augroup END

