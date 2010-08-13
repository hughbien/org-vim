" TODO should auto-fix numbered lists
function OrgAutoPrefixLine()
  let row = line(".")
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
  let row = line(".")
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

" TODO handle missing bars
function OrgFixTable()
  let ltop = line(".")
  while match(getline(ltop), "^\\s*\+\[\+\-\]") != -1 || 
      \ match(getline(ltop), "^\\s*\|") != -1
    let ltop = ltop - 1
  endwhile

  let lbot = line(".")
  while match(getline(lbot), "^\\s*\+\[\+\-\]") != -1 || 
      \ match(getline(lbot), "^\\s*\|") != -1
    let lbot = lbot + 1
  endwhile

  let ltop = ltop + 1
  let lbot = lbot - 1
  if ltop >= lbot
    return
  endif

  let table = map(
    \ filter(getline(ltop, lbot), "v:val !~ '^\\s*\+\[\+\-\]'"),
    \ "split(v:val, '|')")
  if len(table) == 0 || len(table[0]) == 0
    return
  endif

  let maxlength = map(copy(table[0]), "len(v:val)")
  for row in table
    for i in range(len(row))
      if len(row[i]) > maxlength[i]
        let maxlength[i] = len(row[i])
      endif
    endfor
  endfor

  for row in table
    for i in range(len(row))
      if len(row[i]) < maxlength[i]
        let row[i] = row[i] . repeat(" ", maxlength[i] - len(row[i]))
      endif
    endfor
  endfor

  let border = "+" . join(map(copy(maxlength), "repeat('-', v:val)"), "+") . "+"
  let i = ltop
  while i <= lbot
    if getline(i) =~ "\\s*\+\[\+\-]"
      call setline(i, border)
    else
      call setline(i, "|" . join(remove(table, 0), "|") . "|")
    endif
    let i = i + 1
  endwhile
endfunction

function OrgFoldLevel(lnum)
  let line = getline(a:lnum)
  if line =~ "^#"
    return '>' . strlen(matchstr(line, "^#*"))
  else
    let i = a:lnum
    while i > 0
      let line = getline(i)
      if line =~ "^#"
        return strlen(matchstr(line, "^#*"))
      endif
      let i = i - 1
    endwhile
    return '0'
  endif
endfunction

function OrgFoldText()
  return getline(v:foldstart)
endfunction

function OrgFold()
  set foldenable
  set foldmethod=expr
  set foldexpr=OrgFoldLevel(v:lnum)
  set foldtext=OrgFoldText()
  set foldlevel=0
  echo ""
endfunction

" Shortcuts
nmap q= o<ESC>80i=<ESC>0
nmap qn /^#<CR>:echo<CR>
nmap qN ?^#<CR>:echo<CR>
nmap qs /^=\+$<CR>:echo<CR>
nmap qS ?^=\+$<CR>:echo<CR>
nmap qt :call OrgFixTable()<CR>
nmap qo :call OrgAutoPrefixLine()<CR>
nmap qx :call OrgToggleTask()<CR>
nmap qz :call OrgFold()<CR>

