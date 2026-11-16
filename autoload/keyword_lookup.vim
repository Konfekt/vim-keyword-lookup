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
    " Double the backslashes, except those by which K escapes % and # in the
    " keyword, as :terminal expands those like :! does.
    let pattern = substitute(a:pattern, '\\\%([%#]\)\@!', '\\\\', 'g')
    silent execute 'terminal env LESS= MANPAGER="less --pattern=''' . pattern . ''' --hilite-search" man ' . a:page
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

" The section of the key on the cursor line of a gitconfig file as a pattern
" prefix for its entry in git-config(1): 'core\.' below [core], and
" 'remote\.(<[^>]+>\.)?' below [remote "origin"], whose keys are documented
" as remote.<name>.url and so on. Empty on a section header line, where the
" keyword is the section name itself, and outside of any section.
function! keyword_lookup#gitconfig_section() abort
  if getline('.') =~# '^\s*\['
    return ''
  endif
  let header = getline(search('^\s*\[', 'bnW'))
  let matches = matchlist(header, '\v^\s*\[\s*([[:alnum:]-]+)(\s+"|\.)?')
  if empty(matches)
    return ''
  endif
  return matches[1] . '\.' . (empty(matches[2]) ? '' : '(<[^>]+>\.)?')
endfunction
