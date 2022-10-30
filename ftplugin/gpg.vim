if !has('unix')
  finish
endif

if !has('gui_running')
  command! -buffer -nargs=1 Sman
        \ silent exe '!' . 'LESS= MANPAGER="less --pattern=''^\s{,8}--' . <q-args> . '\b'' --hilite-search" man ' . 'gpg' |
        \ redraw!
elseif has('terminal')
  command! -buffer -nargs=1 Sman
        \ silent exe ':term ' . 'env LESS= MANPAGER="less --pattern=''' . escape('^\s{,8}--' . <q-args> . '\b', '\') . ''' --hilite-search" man ' . 'gpg'
else
  finish
endif
setlocal iskeyword+=-
setlocal keywordprg=:Sman

if !exists('b:undo_ftplugin') || empty(b:undo_ftplugin)
  let b:undo_ftplugin = 'setlocal keywordprg< iskeyword<'
else
  let b:undo_ftplugin .= '| setlocal keywordprg< iskeyword<'
endif
