function! OvAutoPrefixLine()
  echo ""
  let row = line(".")
  let line = getline(row)
  let i = row
  while i > 0
        \ && line !~ "^\\s*\\[.\\]" 
        \ && line !~ "^\\s*\-" 
        \ && line !~ "^\\s*\\*" 
        \ && line !~ "^\\s*\-" 
        \ && line !~ "^#" 
        \ && line !~ "^\\s*[0-9]\\+\\." 
        \ && line !~ "^\\s*$"
    let i = i - 1
    let line = getline(i)
  endwhile
  if line =~ "^\\s*\\[.\\]"
    let task = match(line, "\[")
    call append(row, repeat(" ", task) . "[ ] ")
    call cursor(row + 1, task + 4)
  elseif line =~ "^\\s*\-"
    let dash = match(line, "\-")
    call append(row, repeat(" ", dash) . "- ")
    call cursor(row + 1, dash + 2)
  elseif line =~ "^\\s*\\*"
    let asterik = match(line, "\\*")
    call append(row, repeat(" ", asterik) . "* ")
    call cursor(row + 1, asterik + 2)
  elseif line =~ "^#"
    let hash = matchstr(line, "^#*")
    call append(row, hash . " ")
    call cursor(row + 1, strlen(hash) + 1)
  elseif line =~ "^\\s*[0-9]\\+\\."
    let num = matchstr(split(line)[0], "[0-9]*")
    let spaces = line !~ "[0-9]"
    call append(row, repeat(" ", spaces) . (num + 1) . ". ")
    call cursor(row + 1, spaces + strlen(num) + 2)
  endif
endfunction

function! OvToggleTask()
  echo ""
  let row = line(".")
  let line = getline(row)
  if line =~ "\\[ \\]"
    call setline(row, substitute(line, "\\[ \\]", "[x]", ""))
  elseif line =~ "\\[x\\]"
    call setline(row, substitute(line, "\\[x\\]", "[ ]", ""))
  endif
endfunction

function! OvFixOrderedList()
  echo ""
  let ltop = line(".")
  while getline(ltop) =~ "^\\s*[0-9]\\+\\." || 
      \ (getline(ltop) =~ "^\\s" && getline(ltop) !~ "^\\s*$")
    let ltop = ltop - 1
  endwhile

  let lbot = line(".")
  while getline(lbot) =~ "^\\s*[0-9]\\+\\." || 
      \ (getline(lbot) =~ "^\\s" && getline(lbot) !~ "^\\s*$")
    let lbot = lbot + 1
  endwhile

  let ltop = ltop + 1
  let lbot = lbot - 1
  if ltop > lbot
    return
  endif

  let i = 1
  let row = ltop
  while row <= lbot
    let line = getline(row)
    if line =~ "^\\s*[0-9]\\+\\."
      call setline(row, substitute(line, "[0-9]\\+", i, ""))
      let i = i + 1
    endif
    let row = row + 1
  endwhile
endfunction

function! OvFixTable()
  echo ""
  let ltop = line(".")
  while getline(ltop) =~ "^\\s*\+\[\+\-\]*$" || 
      \ getline(ltop) =~ "^\\s*\|"
    let ltop = ltop - 1
  endwhile

  let lbot = line(".")
  while getline(lbot) =~ "^\\s*\+\[\+\-\]*$" || 
      \ getline(lbot) =~ "^\\s*\|"
    let lbot = lbot + 1
  endwhile

  let ltop = ltop + 1
  let lbot = lbot - 1
  if ltop >= lbot
    return
  endif

  let rawTable = map(
    \ filter(getline(ltop, lbot), "v:val !~ '^\\s*\+\[\+\-\]*$'"),
    \ "split(substitute(substitute(" .
          \ "v:val, '^\\s\\+', '', ''), '\\s\\+$', '', ''), '|', 1)")
  if len(rawTable) == 0 || len(rawTable[0]) == 0
    return
  endif

  " Trim cells to include only one space on both sides
  let table = []
  for rawRow in rawTable
    let row = []
    for cell in rawRow
      call add(row, substitute(substitute(
        \ cell, "^\\s\\+", " ", ""), "\\s\\+$", " ", ""))
    endfor
    call add(table, row)
  endfor

  " Find maxlength of each column
  let maxlength = map(copy(table[0]), "len(v:val)")
  for row in table
    for i in range(len(row))
      if i >= len(maxlength)
        call add(maxlength, 0)
      endif
      if len(row[i]) > maxlength[i]
        let maxlength[i] = len(row[i])
      endif
    endfor
  endfor

  " Add whitespace to shorter cells, create whitespace cells as needed
  for row in table
    for i in range(len(maxlength))
      if i >= len(row)
        call add(row, "")
      endif
      if len(row[i]) < maxlength[i]
        let row[i] = row[i] . repeat(" ", maxlength[i] - len(row[i]))
      endif
    endfor
  endfor

  " Regenerate the table, eliminate blank (0 length) columns as needed
  let border = substitute(
    \ "+" . join(map(copy(maxlength), "repeat('-', v:val)"), "+") . "+",
    \ "++", "+", "g")
  let i = ltop
  while i <= lbot
    if getline(i) =~ "^\\s*\+\[\+\-]*$"
      call setline(i, border)
    else
      call setline(i, substitute(
        \ "|" . join(remove(table, 0), "|") . "|", 
        \ "||", "|", "g"))
    endif
    let i = i + 1
  endwhile
endfunction

function! OvFoldLevel(lnum)
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

function! OvFoldText()
  return getline(v:foldstart)
endfunction

function! OvFold()
  echo ""
  set foldenable
  set foldmethod=expr
  set foldexpr=OvFoldLevel(v:lnum)
  set foldtext=OvFoldText()
  set foldlevel=0
endfunction

" Shortcuts
nmap <buffer> q= o<ESC>80i=<ESC>0
nmap <buffer> ql :call OvFixOrderedList()<CR>
nmap <buffer> qn /^#<CR>:echo<CR>
nmap <buffer> qN ?^#<CR>:echo<CR>
nmap <buffer> qs /^=\+$<CR>:echo<CR>
nmap <buffer> qS ?^=\+$<CR>:echo<CR>
nmap <buffer> qt :call OvFixTable()<CR>
nmap <buffer> qo :call OvAutoPrefixLine()<CR>
nmap <buffer> qx :call OvToggleTask()<CR>
nmap <buffer> qz :call OvFold()<CR>
