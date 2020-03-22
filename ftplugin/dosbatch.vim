if executable('help.exe')
  if has('terminal')
    setlocal keywordprg=:term\ help.exe
  else
    setlocal keywordprg=help.exe
  endif
endif
