" Whether man can be shown: by :! in a terminal Vim, else in a :terminal.
function! keyword_lookup#available() abort
  return has('unix') && ((!has('gui_running') && !has('nvim')) || exists(':terminal') == 2)
endfunction

" Show manpage a:page in less, starting at the first match of a:pattern.
function! keyword_lookup#man(page, pattern) abort
  if !has('gui_running') && !has('nvim')
    silent execute '!LESS= MANPAGER="less --pattern=''' . a:pattern . ''' --hilite-search" man ' . a:page
    redraw!
  else
    silent execute 'terminal env LESS= MANPAGER="less --pattern=''' . escape(a:pattern, '\') . ''' --hilite-search" man ' . a:page
  endif
endfunction

" Make K run the buffer-local command a:cmd, and undo that with the ftplugin.
function! keyword_lookup#set(cmd) abort
  setlocal iskeyword+=-
  execute 'setlocal keywordprg=:' . a:cmd

  let undo = 'setlocal keywordprg< iskeyword< | silent! delcommand -buffer ' . a:cmd
  let prev = get(b:, 'undo_ftplugin', '')
  if stridx(prev, undo) < 0
    let b:undo_ftplugin = empty(prev) ? undo : prev . ' | ' . undo
  endif
endfunction

" Look up keywords of the config file of a:page in that manpage.
function! keyword_lookup#config(page) abort
  if !keyword_lookup#available()
    return
  endif
  let b:keyword_lookup_manpage = a:page
  command! -buffer -nargs=1 ConfigKeywordPrg
        \ call keyword_lookup#man(b:keyword_lookup_manpage, '\b' . <q-args> . '\b')
  call keyword_lookup#set('ConfigKeywordPrg')
endfunction

" The section of the cursor line in a gitconfig file as a pattern prefix,
" such as 'core\.'; empty outside of any section.
function! keyword_lookup#gitconfig_section() abort
  let header = getline(search('\v^\s*\[\s*.+\s*\]\s*$', 'bcnW'))
  let matches = matchlist(header, '\v^\s*\[\s*(\k+).*\]\s*$')
  return len(matches) > 1 ? matches[1] . '\.' : ''
endfunction
