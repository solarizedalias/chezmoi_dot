;; extends

(table "[" @opening "]" @closing) @container
(table_array_element "[[" @opening "]]" @closing) @container
(array "[" @opening "]" @closing) @container
(inline_table "{" @opening "}" @closing) @container

