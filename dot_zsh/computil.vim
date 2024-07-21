
function! OptspecFromHelp(start, end) abort
  execute a:start . ',' . a:end . 's/' . "'" . '/\\' . "'" . '/ge'
  execute a:start . ',' . a:end . 's/\v^\s+\zs(.*%(-[^-]|--[^-]\S+)\s)([A-Z][A-Z]+)?\s+(.*)\ze/\1 ' . "'" . '[\3]:\2: ' . "'" . '/ge'
  execute a:start . ',' . a:end . 's/\v(-[^-]|--[^-]\S+)%((,)\s*)?((-[^-]|--[^-]\S+))?/' . "'" . '(\1 \3)' . "'" . '{\1\2\3}/e'
  execute a:start . ',' . a:end . 's/\v\S\zs\s\s\ze\S//ge'
  execute a:start . ',' . a:end . 's/\v' . "'" . '\(\s*(-[^-]|--[^-]\S+)\s*\)' . "'" . '\{\1}' . "'" . '/' . "'" . '\1/e'
  execute a:start . ',' . a:end . 's/\v:: //e'
  execute a:start . ',' . a:end . 's/$/ \\/e'
endfunction

function! EchoOptspecFromHelp(start, end) abort
  echo a:start . ',' . a:end . 's/' . "'" . '/\\' . "'" . '/ge'
  echo a:start . ',' . a:end . 's/\v^\s+\zs(.*%(-[^-]|--[^-]\S+)\s)([A-Z][A-Z]+)?\s+(.*)\ze/\1 ' . "'" . '[\3]:\2: ' . "'" . '/ge'
  echo a:start . ',' . a:end . 's/\v(-[^-]|--[^-]\S+)%((,)\s*)?((-[^-]|--[^-]\S+))?/' . "'" . '(\1 \3)' . "'" . '{\1\2\3}/e'
  echo a:start . ',' . a:end . 's/\v\S\zs\s\s\ze\S//ge'
  echo a:start . ',' . a:end . 's/\v' . "'" . '\(\s*(-[^-]|--[^-]\S+)\s*\)' . "'" . '\{\1}' . "'" . '/' . "'" . '\1/e'
  echo a:start . ',' . a:end . 's/\v:: //e'
  echo a:start . ',' . a:end . 's/$/ \\/e'
endfunction

