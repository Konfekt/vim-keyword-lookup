if !has('unix')
  finish
endif

if !has('gui_running')
  command! -buffer -nargs=1 GitKeywordPrg
        \ silent exe '!' . 'LESS= MANPAGER="less --pattern=''^\s{,8}' . KeywordLookup_gitconfig() . <q-args> . '\b'' --hilite-search" man ' . 'git-config' |
        \ redraw!
elseif has('terminal')
  command! -buffer -nargs=1 GitKeywordPrg
        \ silent exe 'term ' . 'env LESS= MANPAGER="less --pattern=''' . escape('^\s{,8}' . KeywordLookup_gitconfig() . <q-args> . '\b', '\') . ''' --hilite-search" man ' . 'git-config'
else
  finish
endif

if !exists('*KeywordLookup_gitconfig')
function KeywordLookup_gitconfig() abort
  let matches = matchlist(getline(search('\v^\s*\[\s*.+\s*\]\s*$', 'nbWz')), '\v^\s*\[\s*(\k+).*\]\s*$')
  return len(matches) > 1 ? matches[1] . '\.' : ''
endfunction
endif

setlocal iskeyword+=-
setlocal keywordprg=:GitKeywordPrg

if !exists('b:undo_ftplugin') || empty(b:undo_ftplugin)
  let b:undo_ftplugin = 'setlocal keywordprg< iskeyword<  | sil! delc -buffer GitKeywordPrg'
else
  let b:undo_ftplugin .= '| setlocal keywordprg< iskeyword<  | sil! delc -buffer GitKeywordPrg'
endif
