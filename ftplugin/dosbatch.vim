if executable('help.exe')
  if has('terminal')
    setlocal keywordprg=:term\ help.exe
  else
    setlocal keywordprg=help.exe
  endif
endif

if !exists('b:undo_ftplugin') || empty(b:undo_ftplugin)
  let b:undo_ftplugin = 'setlocal keywordprg<'
else
  let b:undo_ftplugin .= '| setlocal keywordprg<'
endif
