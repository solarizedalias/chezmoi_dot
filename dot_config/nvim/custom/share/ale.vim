
let g:ale_sign_priority = 10
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_disable_lsp = 1

" Overridden in has('nvim')
let g:ale_echo_cursor = 1
let g:ale_cursor_detail = 0

let g:ale_hover_cursor = 0
let g:ale_hover_to_preview = 0
let g:ale_close_preview_on_insert = 1
let g:ale_echo_delay = 100

let g:ale_linters = {
      \ 'nim':        [ 'nimcheck' ],
      \ 'vim':        [ 'vint' ],
      \ 'javascript': [ 'eslint' ],
      \ 'typescript': [],
      \ 'jsonc':      [],
      \ 'rust':       [],
      \}

let g:ale_fixers = {
      \ '*':          [ 'trim_whitespace' ],
      \ 'nim':        [ 'nimpretty', 'trim_whitespace' ],
      \ 'c':          [ 'clang-format' ],
      \ 'lua':        [ 'stylua' ],
      \ 'javascript': [ 'prettier' ],
      \ 'rust':       [ 'rustfmt' ],
      \}

let g:ale_fix_on_save_ignore = {
      \ 'nim': [ 'nimpretty' ],
      \ 'javascript': [ 'xo', 'eslint' ]
      \ }

let g:ale_pattern_options = {
      \ '\.txt$'          : {'ale_linters': [], 'ale_fixers': []},
      \}

let g:ale_rust_cargo_check_tests = 1

" If you configure g:ale_pattern_options outside of vimrc, you need this.
let g:ale_pattern_options_enabled = 1

function! s:ale_on_readonly() abort
  if v:option_new ==# 1
    ALEDisableBuffer
    let b:ale_linters = {}
    let b:ale_fixers = {}
  endif
endfunction

augroup custom_ale
  autocmd!
  autocmd OptionSet readonly call s:ale_on_readonly()
augroup END

" javascript
let g:ale_javascript_prettier_options = '--config-precedence prefer-file --arrow-parens avoid'

