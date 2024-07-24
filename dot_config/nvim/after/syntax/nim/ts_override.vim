
highlight  link @keyword.when                PreCondit
highlight  link @keyword.import              Include
highlight  link @keyword.derective           PreProc
highlight  link @keyword.exception           Exception
highlight  link @keyword.structure           Structure

highlight  link @function.macro              Macro

highlight  link @module                      Identifier
highlight! link @variable                    Identifier
highlight  link @pragma_name                 Normal
highlight  link @builtin_proc_pragma         @keyword.derective
highlight  link @varargs_conv                Normal
highlight  link @keyword.operator            Operator
highlight  link @type.qualifier              Keyword
highlight  link @punctuation.exported_symbol Tag

highlight  link @variable.builtin            Special
highlight  link @variable.member             Normal
highlight  link @variable.parameter          Normal
highlight  link @constant.builtin            Constant

" reverting part of recent alaviss/nim.nvim syntax changes
highlight  link nimSugField                  Identifier
highlight  link nimSugForVar                 Identifier
highlight  link nimSugParam                  Identifier
highlight  link nimSugGenericParam           Type
highlight  link nimPreProcStmt               Macro

