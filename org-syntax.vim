" vi-org syntax file
" Language: org
" Maintainer: Hugh Bien (http://hughbien.com)

syntax clear

syn match orgTag             "@[a-zA-Z0-9-_]\+"
syn match orgHighlight       "{{.*}}"
syn match orgLink            "[a-zA-Z]\+://[^ ]\+"
syn match orgTitle           "^\#.*" contains=orgTag,orgLink
syn match orgTitle2          "^\##.*" contains=orgTag,orgLink
syn match orgTitle3          "^\###.*" contains=orgTag,orgLink
syn match orgTitle4          "^\####.*" contains=orgTag,orgLink
syn match orgTitle5          "^\#####.*" contains=orgTag,orgLink
syn match orgTask            "^\s*\[ \]"
syn match orgTaskDone        "^\s*\[x\].*" contains=orgTag,orgLink
syn match orgTableBorder     "^\s*+-\(-\|+\)*"
syn match orgTableCell       "|"
syn match orgListItem        "^\s*\(-\|*\)"
syn match orgNumListItem     "^\s*[0-9]\+\."

hi def link orgTag           Constant
hi def link orgHighlight     Error
hi def link orgLink          Underlined
hi def link orgTitle         String
hi def link orgTitle2        Todo
hi def link orgTitle3        Label
hi def link orgTitle4        Function
hi def link orgTitle5        Operator
hi def link orgTask          Label
hi def link orgTaskDone      Ignore
hi def link orgTableBorder   Label
hi def link orgTableCell     Label
hi def link orgListItem      Label
hi def link orgNumListItem   Label
