" Vim syntax file
" Language:         EBNF
" Maintainer:       Hans Fugal
" Last Change:      $Date: 2003/01/28 14:42:09 $
" Version:          $Id: ebnf.vim,v 1.1 2003/01/28 14:42:09 fugalh Exp $
" With thanks to Michael Brailsford for the BNF syntax file.

" Quit when a syntax file was already loaded
if v:version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

syntax match  ebnfNonTerminalDef   /^\s*\zs[A-Za-z][0-9A-Za-z_]*/
      \ skipwhite
      \ skipempty
      \ nextgroup=ebnfSeperator

syntax match  ebnfNonTerminal      / \zs[A-Za-z][0-9A-Za-z_]*\ze\%( \|[?*+;]\|$\)/
syntax match  ebnfSeperator        /\(:=\|=\)/ contained nextgroup=ebnfProduction skipwhite skipempty

syntax region ebnfProduction start=/\zs[^\.;]/ end=/[\.;]/me=e-1
      \ contained
      \ contains=ebnfSpecial,ebnfDelimiter,ebnfTerminal,ebnfComment,ebnfNonTerminal,ebnfGroup
      \ nextgroup=ebnfEndProduction
      \ skipwhite
      \ skipempty

syntax match  ebnfEndProduction   /[\.;]/    contained

syntax match  ebnfDelimiter       /[|]/      contained
syntax match  ebnfSpecial         /[\-\*+?]/ contained

syntax match  ebnfGroup           /[()]/     contained

" syntax region ebnfSpecialSequence matchgroup=Delimiter start=/?/ end=/?/ contained
syntax region ebnfTerminal matchgroup=delimiter start=/"/ end=/"/ contained
syntax region ebnfTerminal matchgroup=delimiter start=/'/ end=/'/ contained
syntax region ebnfComment start='(\*' end='\*)'

highlight link ebnfComment         Comment
highlight link ebnfNonTerminalDef  Special
highlight link ebnfNonTerminal     Identifier
highlight link ebnfSeperator       ebnfSpecial
highlight link ebnfEndProduction   Delimiter
highlight link ebnfDelimiter       ebnfSpecial
highlight link ebnfSpecial         Operator
" highlight link ebnfSpecialSequence Statement
highlight link ebnfTerminal        Constant
highlight link ebnfGroup           ebnfRainbow_lv0_o0

