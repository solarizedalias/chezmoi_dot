;; extends

(comment (comment_content) @injection.content
         (#set! injection.language "comment"))

(block_comment (comment_content) @injection.content
         (#set! injection.language "comment"))

(documentation_comment (comment_content) @injection.content
         (#set! injection.language "comment"))

(block_documentation_comment (comment_content) @injection.content
         (#set! injection.language "comment"))

