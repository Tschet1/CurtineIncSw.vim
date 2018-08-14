function! FindInc()
  let dirname=fnamemodify(expand("%:p"), ":h")
  let cmd="find . " . dirname . " -type f -iname " . t:IncSw . " | head -n1 | tr -d '\n'"

  let findRes=system(cmd)

  exe "e " findRes
endfun

function! FindIncGit()
  let cmd="cd \"$(git rev-parse --show-toplevel|sed -e 's/ /\\ /g')\"; echo \"$(git rev-parse --show-toplevel)/$(git ls-files -- '*/" . t:IncSw . "' | head -n1 | tr -d '\n')\" "
  let findRes=system(cmd)
  exe "e " findRes
endfun

function! CurtineIncSw()
  if exists("t:IncSw")
    e#
    return 0
  endif

  if match(expand("%"), '\.c') > 0
    let t:IncSw=substitute(expand("%:t"), '\.c\(.*\)', '.h*', "")
  elseif match(expand("%"), "\\.h") > 0
    let t:IncSw=substitute(expand("%:t"), '\.h\(.*\)', '.c*', "")
  endif

  let output=system('git rev-parse')
  if !v:shell_error
" we are in git
    call FindIncGit()
  else
    call FindInc()
  endif
endfun

