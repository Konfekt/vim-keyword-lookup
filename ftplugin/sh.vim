if !has('gui_running') && executable('less')
  command! -buffer -nargs=1 Help silent exe '!bash -c "{ help "<args>" 2>/dev/null || man "<args>"; } | LESS= less"' | redraw!
elseif has('terminal')
  command! -buffer -nargs=1 Help silent exe ':term bash -c "help "<args>" 2>/dev/null || man "<args>""'
else
  command! -buffer -nargs=1 Help echo system('bash -c "help <args>" 2>/dev/null || man "<args>"')
endif
setlocal keywordprg=:Help
