
let s:cpo_save = &cpoptions
set cpoptions&vim

syntax region ebnfComment start=/(\*/ end=/\*)/

let &cpoptions = s:cpo_save

