function! FindInc()
  let dirname=fnamemodify(expand("%:p"), ":h")
  let target_file=b:inc_sw
  let cmd="find " . dirname . " . -type f -iname \"" . target_file . "\" -print -quit"
  let find_res=system(cmd)
  if filereadable(find_res)
    return 0
  endif

  exe "e " find_res
endfun

function! FindIncGit()
  let cmd="cd \"$(git rev-parse --show-toplevel|sed -e 's/ /\\ /g')\"; echo \"$(git rev-parse --show-toplevel)/$(git ls-files -- '*/" . t:IncSw . "' | head -n1 | tr -d '\n')\" "
  let findRes=system(cmd)
  exe "e " findRes
endfun

function! CurtineIncSw()
  if exists("b:inc_sw")
    e#
    return 0
  endif
  if match(expand("%"), '\.c') > 0
    let b:inc_sw=substitute(expand("%:t"), '\.c\(.*\)', '.h*', "")
  elseif match(expand("%"), "\\.h") > 0
    let b:inc_sw=substitute(expand("%:t"), '\.h\(.*\)', '.c*', "")
  endif

  let output=system('git rev-parse')
  if !v:shell_error
" we are in git
    call FindIncGit()
  else
    call FindInc()
  endif
endfun

