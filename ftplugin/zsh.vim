if !has('gui_running') && executable('less')
  command! -buffer -nargs=1 RunHelp silent exe '!zsh -ic "autoload -Uz run-help; run-help <args> 2>/dev/null | LESS= less"' | redraw!
elseif has('terminal')
  command! -buffer -nargs=1 RunHelp silent exe ':term zsh -ic "autoload -Uz run-help; run-help <args>"'
else
  command! -buffer -nargs=1 RunHelp echo system('zsh -ic "autoload -Uz run-help; run-help <args> 2>/dev/null"')
endif
" " Alternatively, use the zshall manpage:
" if !has('gui_running')
"   command! -buffer -nargs=1 RunHelp
"         \ silent exe '!' . 'LESS= MANPAGER="less --pattern=''^\s*' . <q-args> . '\b'' --hilite-search" man zshall' |
"         \ redraw!
" elseif has('terminal')
"   command! -buffer -nargs=1 RunHelp
"         \ silent exe 'term ' . 'env LESS= MANPAGER="less --pattern=''^\\s*' . <q-args> . '\\b'' --hilite-search" man zshall'
" else
"   command! -buffer -nargs=1 RunHelp echo system('env LESS= MANPAGER="less --pattern=''^\\s*' . <q-args> . '\\b'' --hilite-search" man zshall')
" endif
setlocal keywordprg=:RunHelp

if !exists('b:undo_ftplugin') || empty(b:undo_ftplugin)
  let b:undo_ftplugin = 'setlocal keywordprg<'
else
  let b:undo_ftplugin .= '| setlocal keywordprg<'
endif
