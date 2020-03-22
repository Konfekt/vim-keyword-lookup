if !has('unix')
  finish
endif

if !has('gui_running')
  command! -buffer -nargs=1 Sman
        \ silent exe '!' . 'LESS= MANPAGER="less --pattern=''\b' . <q-args> . '\b'' --hilite-search --squeeze-blank-lines" man ' . 'ssh_config' |
        \ redraw!
elseif has('terminal')
  command! -buffer -nargs=1 Sman
        \ silent exe 'term ' . 'env LESS= MANPAGER="less --pattern=''\\b' . <q-args> . '\\b'' --hilite-search --squeeze-blank-lines" man ' . 'ssh_config'
else
  finish
endif
setlocal iskeyword+=-
setlocal keywordprg=:Sman