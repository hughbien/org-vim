" Set filetype
au BufRead,BufNewFile *.org set filetype=org

" TODO should work with multi-line lists/outlines, should auto-fix numbered lists
function OrgAutoPrefixLine()
  let row = getpos(".")[1]
  let line = getline(row)
  let task = match(line, "\[")
  let dash = match(line, "\-")
  let asterik = match(line, "\*")
  let hash = matchstr(line, "^#*")
  let num = matchstr(line, "^[0-9]*")
  if task > -1
    let failed = append(row, repeat(" ", task) . "[ ] ")
    let failed = cursor(row + 1, task + 4)
  elseif dash > -1
    let failed = append(row, repeat(" ", dash) . "- ")
    let failed = cursor(row + 1, dash + 2)
  elseif asterik > -1
    let failed = append(row, repeat(" ", asterik) . "* ")
    let failed = cursor(row + 1, asterik + 2)
  elseif strlen(hash) > 0
    let failed = append(row, hash . " ")
    let failed = cursor(row + 1, strlen(hash) + 1)
  elseif strlen(num) > 0
    let failed = append(row, (num + 1) . ". ")
    let failed = cursor(row + 1, strlen(num) + 2)
  endif
  echo ""
endfunction

function OrgToggleTask()
  let row = getpos(".")[1]
  let line = getline(row)
  let task = match(line, "\\[ \\]")
  let done = match(line, "\\[x\\]")
  if task > -1
    let failed = setline(row, substitute(line, "\\[ \\]", "[x]", ""))
  elseif done > -1
    let failed = setline(row, substitute(line, "\\[x\\]", "[ ]", ""))
  endif
  echo ""
endfunction

" TODO make it work
function OrgFixTable()
endfunction

" TODO make it work
function OrgFoldLevel()
endfunction

" Shortcuts
imap <C-O><C-O> <ESC>:call OrgAutoPrefixLine()<CR>a
imap <C-O><C-X> <ESC>:call OrgToggleTask()<CR>a

nmap qo :call OrgAutoPrefixLine()<CR>
nmap qx :call OrgToggleTask()<CR>
