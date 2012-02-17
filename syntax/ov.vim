" Language: ov
" Maintainer: Hugh Bien (http://hughbien.com)

syntax clear

syn match ovTag             "@[a-zA-Z0-9-_]\+"
syn match ovHighlight       "{{[^}]*}}"
syn match ovLink            "[a-zA-Z]\+://[^ ]\+"
syn match ovTitle           "^\#.*" contains=ovTag,ovLink
syn match ovTitle2          "^\##.*" contains=ovTag,ovLink
syn match ovTitle3          "^\###.*" contains=ovTag,ovLink
syn match ovTitle4          "^\####.*" contains=ovTag,ovLink
syn match ovTitle5          "^\#####.*" contains=ovTag,ovLink
syn match ovTask            "^\s*\[ \]"
syn match ovTaskDone        "^\s*\[x\].*" contains=ovTag,ovLink
syn match ovTableBorder     "^\s*+-\(-\|+\)*"
syn match ovTableCell       "|"
syn match ovListItem        "^\s*\(-\|*\)"
syn match ovNumListItem     "^\s*[0-9]\+\."
syn match ovSeparator       "^=\+$"

hi def link ovTag           Constant
hi def link ovHighlight     Identifier
hi def link ovLink          Underlined
hi def link ovTitle         Identifier
hi def link ovTitle2        Type
hi def link ovTitle3        PreProc
hi def link ovTitle4        Statement
hi def link ovTitle5        Constant
hi def link ovTask          Label
hi def link ovTaskDone      Ignore
hi def link ovTableBorder   Label
hi def link ovTableCell     Label
hi def link ovListItem      Label
hi def link ovNumListItem   Label
hi def link ovSeparator     Ignore
