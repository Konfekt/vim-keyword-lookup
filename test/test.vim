" Headless tests for vim-keyword-lookup; run through test/run.sh.
let s:errors = []
let s:tmp = fnamemodify(tempname(), ':p')
call mkdir(s:tmp, 'p')
let s:log = s:tmp . '/man.log'
let $KEYWORD_LOOKUP_LOG = s:log

function! s:check(cond, msg) abort
  if !a:cond
    call add(s:errors, a:msg)
  endif
endfunction

function! s:file(path, lines) abort
  let path = s:tmp . '/' . a:path
  call mkdir(fnamemodify(path, ':h'), 'p')
  call writefile(a:lines, path)
  return path
endfunction

" Run K on the cursor keyword and return what the fake man recorded.
function! s:lookup() abort
  call delete(s:log)
  normal! K
  if has('nvim')
    call wait(5000, {-> filereadable(s:log)})
  endif
  let lines = filereadable(s:log) ? readfile(s:log) : []
  if &buftype ==# 'terminal'
    bwipeout!
  endif
  return lines
endfunction

function! s:count(haystack, needle) abort
  return len(split(a:haystack, a:needle, 1)) - 1
endfunction

" Config files are detected by path, including XDG locations.
let s:cases = {
      \ 'a/mpv/mpv.conf': 'mpv',
      \ 'home/.mbsyncrc': 'mbsync',
      \ 'home/.config/msmtp/config': 'msmtp',
      \ 'home/.latexmkrc': 'latexmk',
      \ 'home/.config/latexmk/latexmkrc': 'latexmk',
      \ 'home/.config/tig/config': 'tigrc',
      \ 'etc/thermald/thermal-conf.xml': 'thermal-conf.xml',
      \ 'home/.imapfilter/config.lua': 'imapfilter_config',
      \ }
for [s:path, s:page] in items(s:cases)
  execute 'edit' fnameescape(s:file(s:path, ['x']))
  call s:check(get(b:, 'keyword_lookup_manpage', '') ==# s:page,
        \ s:path . ': manpage ' . string(get(b:, 'keyword_lookup_manpage', '')) . ' != ' . string(s:page))
  call s:check(&l:keywordprg ==# ':ConfigKeywordPrg', s:path . ': keywordprg=' . &l:keywordprg)
  bwipeout!
endfor

" Redisplaying a buffer must not grow b:undo_ftplugin.
let s:mpv = s:file('b/mpv/mpv.conf', ['save-position-on-quit', 'volume-max=100'])
let s:other = s:file('b/other.txt', ['x'])
execute 'edit' fnameescape(s:mpv)
execute 'edit' fnameescape(s:other)
execute 'edit' fnameescape(s:mpv)
doautocmd BufWinEnter
call s:check(s:count(get(b:, 'undo_ftplugin', ''), 'ConfigKeywordPrg') == 1,
      \ 'undo_ftplugin repeated: ' . string(get(b:, 'undo_ftplugin', '')))
call s:check(&l:iskeyword =~# '-', 'iskeyword lacks -')

" K opens the manpage of the config file at the keyword.
call cursor(2, 1)
let s:out = s:lookup()
call s:check(index(s:out, 'ARGS=mpv') >= 0, 'mpv: man args ' . string(s:out))
call s:check(index(s:out, 'LESS=') >= 0, 'mpv: LESS not cleared ' . string(s:out))
call s:check(index(s:out, 'MANPAGER=less --pattern=''\bvolume-max\b'' --hilite-search') >= 0,
      \ 'mpv: pager ' . string(s:out))

" Undoing the ftplugin drops the lookup again.
execute b:undo_ftplugin
call s:check(&l:keywordprg ==# &g:keywordprg, 'mpv undo: keywordprg=' . &l:keywordprg)
call s:check(exists(':ConfigKeywordPrg') != 2, 'mpv undo: command still defined')
bwipeout!

" gitconfig: the key is looked up below its section.
let s:git = s:file('c/.gitconfig', ['[core]', "\teditor = vim", '[remote "origin"]', "\turl = x"])
execute 'edit' fnameescape(s:git)
call s:check(&filetype ==# 'gitconfig', 'gitconfig: filetype=' . &filetype)
call s:check(&l:keywordprg ==# ':GitKeywordPrg', 'gitconfig: keywordprg=' . &l:keywordprg)
call cursor(2, 2)
let s:out = s:lookup()
call s:check(index(s:out, 'ARGS=git-config') >= 0, 'gitconfig: man args ' . string(s:out))
call s:check(index(s:out, 'MANPAGER=less --pattern=''^\s{,8}core\.editor\b'' --hilite-search') >= 0,
      \ 'gitconfig: pager ' . string(s:out))
" On a section header itself, its own section is used.
call cursor(3, 1)
let s:out = s:lookup()
call s:check(index(s:out, 'MANPAGER=less --pattern=''^\s{,8}remote\.remote\b'' --hilite-search') >= 0,
      \ 'gitconfig header: pager ' . string(s:out))

" Changing the filetype undoes the gitconfig settings.
set filetype=text
call s:check(&l:keywordprg ==# &g:keywordprg, 'gitconfig undo: keywordprg=' . &l:keywordprg)
call s:check(exists(':GitKeywordPrg') != 2, 'gitconfig undo: command still defined')
bwipeout!

call delete(s:tmp, 'rf')
" Ex mode drops :echo output, so report through stdout.
if empty(s:errors)
  call writefile(['ok'], '/dev/stdout')
  qall!
endif
call writefile(map(s:errors, '"FAIL: " . v:val'), '/dev/stdout')
cquit!
