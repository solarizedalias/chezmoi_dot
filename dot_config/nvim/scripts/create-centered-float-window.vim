if !has('nvim')
  finish
endif

function! CreateCenteredFloatingWindow()
  let l:width = min([&columns - 4, max([80, &columns - 20])])
  let l:height = min([&lines - 4, max([20, &lines - 10])])
  let l:top = ((&lines - l:height) / 2) - 1
  let l:left = (&columns - l:width) / 2
  let l:opts = {'relative': 'editor', 'row': l:top, 'col': l:left, 'width': l:width, 'height': l:height, 'style': 'minimal'}

  let l:top = "╭" . repeat("─", l:width - 2) . "╮"
  let l:mid = "│" . repeat(" ", l:width - 2) . "│"
  let l:bot = "╰" . repeat("─", l:width - 2) . "╯"
  let l:lines = [l:top] + repeat([l:mid], l:height - 2) + [l:bot]
  let s:buf = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(s:buf, 0, -1, v:true, l:lines)
  let l:border_win = nvim_open_win(s:buf, v:true, l:opts)
  set winhighlight=Normal:Floating
  let l:opts.row += 1
  let l:opts.height -= 2
  let l:opts.col += 2
  let l:opts.width -= 4
  let l:main_win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, l:opts)
  augroup CenteredFloatingWindow
    autocmd!
    autocmd BufWipeout <buffer> execute 'bwipeout ' . s:buf
    execute 'autocmd WinClosed ' . s:main_win   . ' call nvim_win_close('.s:border_win.', v:true)'
    execute 'autocmd WinClosed ' . s:border_win . ' call nvim_win_close('.s:main_win.', v:true)'
  augroup END
  return [s:main_win, s:border_win]
endfunction

function! CreateBorderWindow(window) abort
  let l:opts = nvim_win_get_config(a:window)
  let l:config_main = l:opts
  let l:config_main.row += 1
  let l:config_main.height -= 2
  " let l:config_main.col += 2
  call nvim_win_set_config(a:window, l:config_main)
  " let l:buffer nvim_win_get_buffer(a:window)
  let l:opts.row -= 1
  let l:opts.height += 2
  let l:opts.col -= 2
  let l:opts.width += 4
  let l:opts.style = 'minimal'
  " let l:opts.relative = 'cursor'
  let l:opts.focusable = v:false
  " call remove(l:opts, 'win')
  let l:top = "╭" . repeat("─", l:opts.width - 3) . "╮"
  let l:mid = "│" . repeat(" ", l:opts.width - 3) . "│"
  let l:bot = "╰" . repeat("─", l:opts.width - 3) . "╯"
  let l:lines = [l:top] + repeat([l:mid], l:opts.height - 2) + [l:bot]
  let l:buf = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(l:buf, 0, -1, v:true, l:lines)
  let l:border_win = nvim_open_win(l:buf, v:true, l:opts)
  set winhighlight=Normal:Floating
  augroup BorderWindow
    autocmd!
    autocmd BufWipeout <buffer> execute 'bwipeout ' . l:buf
    execute 'autocmd WinClosed ' . a:window . ' call nvim_win_close('.l:border_win.', v:true)'
  augroup END
  call nvim_set_current_win(a:window)
  return l:border_win
endfunction

" let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }

function! IsFloatWin(window) abort
  try
    let l:config = nvim_win_get_config(a:window)
  catch /E5555/
    let l:config = {}
  endtry
  return has_key(l:config, 'relative') && l:config.relative !=# ''
endfunction

function! GetNewWinId() abort
  let l:win = win_getid(winnr('$'))
  return l:win
endfunction

function! CallBorderOnFloat() abort
  let l:new_win = GetNewWinId()
  if IsFloatWin(l:new_win)
    call CreateBorderWindow(l:new_win)
  endif
endfunction

function! CloseFloat() abort
  let l:top = GetNewWinId()
  if IsFloatWin(l:top)
    call nvim_win_close(l:top, v:true)
  endif
endfunction

" augroup VimLspFloat
"   autocmd!
"   " autocmd WinNew
"   autocmd WinEnter * if IsFloatWin(win_getid(winnr('#'))) | call CreateBorderWindow(win_getid(winnr('#'))) | endif
" augroup END

