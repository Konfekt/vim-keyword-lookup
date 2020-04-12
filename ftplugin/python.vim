if !exists('g:pydoc_executable')
  let g:pydoc_executable = has('win32') ? 'python -m pydoc' : 'pydoc'
endif
if executable(split(g:pydoc_executable)[0])
  if !has('gui_running')
    command! -buffer -nargs=1 RunHelp silent exe '!' . g:pydoc_executable . ' "<args>" 2>/dev/null' | redraw!
  elseif has('terminal')
    command! -buffer -nargs=1 RunHelp silent exe ':term ' . g:pydoc_executable . ' "<args>"'
  else
    command! -buffer -nargs=1 RunHelp echo system(g:pydoc_executable . ' "<args>" 2>/dev/null')
  endif
  setlocal keywordprg=:RunHelp

  if !exists('b:undo_ftplugin') || empty(b:undo_ftplugin)
    let b:undo_ftplugin = 'setlocal keywordprg< iskeyword<'
  else
    let b:undo_ftplugin .= '| setlocal keywordprg< iskeyword<'
  endif
endif
