if !has('unix')
  finish
endif

au BufRead,BufNewFile,BufFilePost .inputrc                  call s:keywordprg('3 readline')
au BufRead,BufNewFile,BufFilePost */.gnupg/gpg-agent.conf    call s:keywordprg('gpg-agent')
au BufRead,BufNewFile,BufFilePost .mbsyncrc                  call s:keywordprg('mbsync')
au BufRead,BufNewFile,BufFilePost .msmtprc                  call s:keywordprg('msmtp')
au BufRead,BufNewFile,BufFilePost .tigrc                     call s:keywordprg('tigrc')
au BufRead,BufNewFile,BufFilePost .latexmkrc                 call s:keywordprg('latexmk')
au BufRead,BufNewFile,BufFilePost */zathura/zathurarc        call s:keywordprg('zathurarc')
au BufRead,BufNewFile,BufFilePost */ranger/rc.conf           call s:keywordprg('ranger')
au BufRead,BufNewFile,BufFilePost */ranger/rifle.conf        call s:keywordprg('rifle')
au BufRead,BufNewFile,BufFilePost redshift.conf              call s:keywordprg('redshift')
au BufRead,BufNewFile,BufFilePost */.recoll/recoll.conf      call s:keywordprg('recoll.conf')
au BufRead,BufNewFile,BufFilePost */thermal/thermal-conf.xml call s:keywordprg('thermal-conf.xml')
au BufRead,BufNewFile,BufFilePost */.imapfilter/*.lua        call s:keywordprg('imapfilter_config')

function! s:keywordprg(man)
  let b:keyword_lookup_manpage = a:man
  if !has('gui_running')
    command! -buffer -nargs=1 Sman
          \ silent exe '!' . 'LESS= MANPAGER="less --pattern=''\b' . <q-args> . '\b'' --hilite-search" man ' . b:keyword_lookup_manpage |
          \ redraw!
  elseif has('terminal')
    command! -buffer -nargs=1 Sman
          \ silent exe 'term ' . 'env LESS= MANPAGER="less --pattern=''' . escape('\b' . <q-args> . '\b', '\') . ''' --hilite-search" man ' . b:keyword_lookup_manpage
  else
    return
  endif
  setlocal iskeyword+=-
  setlocal keywordprg=:Sman
  if !exists('b:undo_ftplugin') || empty(b:undo_ftplugin)
    let b:undo_ftplugin = 'setlocal keywordprg< iskeyword<'
  else
    let b:undo_ftplugin .= '| setlocal keywordprg< iskeyword<'
  endif
endfunction
