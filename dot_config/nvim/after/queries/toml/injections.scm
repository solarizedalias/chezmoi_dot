;; extends

; Dein

; hook_*

(table_array_element
  (bare_key) @_array_element_name
  (pair
    ((bare_key) @_table_key
     (string) @injection.content))
  (#eq? @_array_element_name "plugins")
  (#any-of? @_table_key
    "hook_add" "hook_depends_update" "hook_done_update"
    "hook_post_update" "hook_source" "hook_post_source")
  (#vim-match? @injection.content "^('''|\"\"\")")
  (#offset! @injection.content 0 3 0 -3)
  (#set! injection.language "vim"))

(table_array_element
  (bare_key) @_array_element_name
  (pair
    ((bare_key) @_table_key
     (string) @injection.content))
  (#eq? @_array_element_name "plugins")
  (#any-of? @_table_key
    "hook_add" "hook_depends_update" "hook_done_update"
    "hook_post_update" "hook_source" "hook_post_source")
  (#vim-match? @injection.content "^('[^']|\"[^\"])")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "vim"))

; lua_*

(table_array_element
  (bare_key) @_array_element_name
  (pair
    ((bare_key) @_table_key
     (string) @injection.content))
  (#eq? @_array_element_name "plugins")
  (#any-of? @_table_key
   "lua_add" "lua_depends_update" "lua_done_update"
   "lua_post_update" "lua_source" "lua_post_source")
  (#vim-match? @injection.content "^('''|\"\"\")")
  (#offset! @injection.content 0 3 0 -3)
  (#set! injection.language "lua"))

(table_array_element
  (bare_key) @_array_element_name
  (pair
    ((bare_key) @_table_key
     (string) @injection.content))
  (#eq? @_array_element_name "plugins")
  (#any-of? @_table_key
   "lua_add" "lua_depends_update" "lua_done_update"
   "lua_post_update" "lua_source" "lua_post_source")
  (#vim-match? @injection.content "^('[^']|\"[^\"])")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "lua"))

