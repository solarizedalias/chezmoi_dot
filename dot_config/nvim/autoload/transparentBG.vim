" =============================================================================
" Filename: autoload/lightline/colorscheme/transparentBG.vim
" Author: solarizedalias
" License: MIT License
" Last Change: 2020/05/09 00:00:00.
" =============================================================================
let s:none = [ 'NONE', 'NONE' ]

let s:base03 = [ '#151513', 233 ]
let s:base02 = [ '#30302c ', 236 ]
let s:base01 = [ '#4e4e43', 239 ]
let s:base00 = [ '#666656', 242  ]
let s:base0 = [ '#808070', 244 ]
let s:base1 = [ '#949484', 246 ]
let s:base2 = [ '#a8a897', 248 ]
let s:base3 = [ '#e8e8d3', 253 ]
let s:yellow = [ '#ffb964', 215 ]
let s:orange = [ '#fad07a', 222 ]
let s:red = [ '#cf6a4c', 167 ]
let s:magenta = [ '#f0a0c0', 217 ]
let s:blue = [ '#8197bf', 103 ]
let s:cyan = [ '#8fbfdc', 110 ]
let s:green = [ '#99ad6a', 107 ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left = [ [ s:base03, s:blue, 'bold' ], [ s:base2, s:none ] ]
let s:p.insert.left = [ [ s:base02, s:green, 'bold' ], [ s:base2, s:none ] ]
let s:p.visual.left = [ [ s:base02, s:magenta, 'bold' ], [ s:base2, s:none ] ]
let s:p.replace.left = [ [ s:base02, s:red, 'bold' ], [ s:base2,  s:none ] ]
let s:p.inactive.left =  [ [ s:base0, s:none ], [ s:base00, s:none ] ]

let s:p.normal.right = [ [ s:base3, s:none ], [ s:blue, s:none ] ]
let s:p.insert.right = [ [ s:base3, s:none ], [ s:green, s:none ] ]
let s:p.visual.right = [ [ s:base3, s:none ], [ s:magenta, s:none ] ]
let s:p.inactive.right = [ [ s:base02, s:none ], [ s:base0, s:none ] ]
let s:p.inactive.middle = [ [ s:base00, s:none ] ]

let s:p.normal.error = [ [ s:red, s:none ] ]
let s:p.normal.warning = [ [ s:yellow, s:none ] ]
let s:p.normal.middle = [ [ s:base0, s:none ] ]

let s:p.tabline.left = [ [ s:base3, s:none ] ]
let s:p.tabline.tabsel = [ [ s:base3, s:none ] ]
let s:p.tabline.middle = [ [ s:base01, s:none ] ]
let s:p.tabline.right = copy(s:p.normal.right)

let g:lightline#colorscheme#transparentBG#palette = lightline#colorscheme#flatten(s:p)

