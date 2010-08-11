" Set filetype
au BufRead,BufNewFile *.org set filetype=org

" TODO should auto-fix numbered lists
function OrgAutoPrefixLine()
  let row = getpos(".")[1]
  let line = getline(row)
  let i = row
  while i > 0
        \ && match(line, "^\\s*\\[.\\]") == -1 
        \ && match(line, "^\\s*\-") == -1 
        \ && match(line, "^\\s*\\*") == -1 
        \ && match(line, "^\\s*\-") == -1 
        \ && match(line, "^#") == -1 
        \ && match(line, "^\\s*[0-9]\\.\\+") == -1 
        \ && match(line, "^\\s*$") == -1
        \ && match(line, "^[^\s]") == -1
    let i = i - 1
    let line = getline(i)
  endwhile
  if match(line, "^\\s*\\[.\\]") != -1
    let task = match(line, "\[")
    let failed = append(row, repeat(" ", task) . "[ ] ")
    let failed = cursor(row + 1, task + 4)
  elseif match(line, "^\\s*\-") != -1
    let dash = match(line, "\-")
    let failed = append(row, repeat(" ", dash) . "- ")
    let failed = cursor(row + 1, dash + 2)
  elseif match(line, "^\\s*\\*") != -1
    let asterik = match(line, "\\*")
    let failed = append(row, repeat(" ", asterik) . "* ")
    let failed = cursor(row + 1, asterik + 2)
  elseif match(line, "^#") != -1
    let hash = matchstr(line, "^#*")
    let failed = append(row, hash . " ")
    let failed = cursor(row + 1, strlen(hash) + 1)
  elseif match(line, "^\\s*[0-9]\\.\\+") != -1
    let num = matchstr(split(line)[0], "[0-9]*")
    let spaces = match(line, "[0-9]")
    let failed = append(row, repeat(" ", spaces) . (num + 1) . ". ")
    let failed = cursor(row + 1, spaces + strlen(num) + 2)
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

" TODO auto-fix ordered lists
function OrgFixOrderedList()
endfunction

" TODO auto-fix tables
function OrgFixTable()
endfunction

" TODO fold levels on hashes
function OrgFoldLevel()
endfunction

" TODO wiki links
" TODO normal links

" Shortcuts
nmap q= o<ESC>80i=<ESC>0
nmap qn /^#<CR>:echo<CR>
nmap qN ?^#<CR>:echo<CR>
nmap qs /^=\+$<CR>:echo<CR>
nmap qS ?^=\+$<CR>:echo<CR>
nmap qo :call OrgAutoPrefixLine()<CR>
nmap qx :call OrgToggleTask()<CR>
