;; extends
; you might want to consider removing the line above and going for full override

[
 "object"
 "enum"
 "tuple"
] @keyword.structure

("when" @keyword.when)

(discard_statement "discard" @keyword)

(pragma_list ["{." "}" ".}"] @punctuation.pragma)

(exported_symbol "*" @punctuation.exported_symbol)

((identifier) @pragma_name
  (#has-ancestor? @pragma_name pragma_list)
  (#set! "priority" 102)
)

((identifier) @boolean
  (#any-of? @boolean "true" "false" "on" "off")
  (#set! "priority" 110))

((identifier) @builtin_proc_pragma
  (#has-ancestor? @builtin_proc_pragma pragma_list)
  (#has-ancestor? @builtin_proc_pragma
   func_declaration proc_declaration converter_declaration iterator_declaration
   method_declaration proc_type)
  (#any-of? @builtin_proc_pragma
   "gcsafe" "noSideEffect" "noreturn" "discardable" "sideEffect" "base" "asmNoStackFrame"
   "nimcall" "closure" "stdcall" "cdecl" "safecall" "inline" "fastcall" "thiscall" "syscall" "noconv"
   "raises" "tags" "forbids" "effectsOf")
  (#set! "priority" 112))

; varargs[SOMETYPE, `I_DONT_WANT_HIGHLIGHT_HERE`]
; ((identifier) @_varargs (#eq? @_varargs "varargs")
;   (argument_list
;     ((_)
;      (accent_quoted
;        (identifier) @varargs_conv (#has-ancestor? @varargs_conv bracket_expression)))))

; (template_declaration
;   name: [
;     (identifier) @macro.template
;     (accent_quoted (identifier) @macro.template)
;     (exported_symbol (identifier) @macro.template)
;     (exported_symbol (accent_quoted (identifier) @macro.template))
;   ])

; (macro_declaration
;   name: [
;     (identifier) @macro
;     (accent_quoted (identifier) @macro)
;     (exported_symbol (identifier) @macro)
;     (exported_symbol (accent_quoted (identifier) @macro))
;   ])

