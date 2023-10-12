if !has('unix')
  finish
endif

au BufWinEnter,BufFilePost */mpv/mpv.conf             call s:keywordprg('mpv')
au BufWinEnter,BufFilePost */yt-dlp/config            call s:keywordprg('yt-dlp')
au BufWinEnter,BufFilePost */youtube-dl/config        call s:keywordprg('youtube-dl')
au BufWinEnter,BufFilePost */.gnupg/gpg-agent.conf    call s:keywordprg('gpg-agent')
au BufWinEnter,BufFilePost .mbsyncrc                  call s:keywordprg('mbsync')
au BufWinEnter,BufFilePost .msmtprc                   call s:keywordprg('msmtp')
au BufWinEnter,BufFilePost .latexmkrc                 call s:keywordprg('latexmk')
au BufWinEnter,BufFilePost NetworkManager.conf        call s:keywordprg('NetworkManager.conf')
au BufWinEnter,BufFilePost .tigrc                     call s:keywordprg('tigrc')
au BufWinEnter,BufFilePost */ranger/rc.conf           call s:keywordprg('ranger')
au BufWinEnter,BufFilePost */ranger/rifle.conf        call s:keywordprg('rifle')
au BufWinEnter,BufFilePost */udiskie/config.yml       call s:keywordprg('udiskie')
au BufWinEnter,BufFilePost */zathura/zathurarc        call s:keywordprg('zathurarc')
au BufWinEnter,BufFilePost redshift.conf              call s:keywordprg('redshift')
au BufWinEnter,BufFilePost */.recoll/recoll.conf      call s:keywordprg('recoll.conf')
au BufWinEnter,BufFilePost */thermal/thermal-conf.xml call s:keywordprg('thermal-conf.xml')
au BufWinEnter,BufFilePost */.imapfilter/*.lua        call s:keywordprg('imapfilter_config')

function! s:keywordprg(man)
  let b:keyword_lookup_manpage = a:man
  if !has('gui_running')
    command! -buffer -nargs=1 ConfigKeywordPrg
          \ silent exe '!' . 'LESS= MANPAGER="less --pattern=''\b' . <q-args> . '\b'' --hilite-search" man ' . b:keyword_lookup_manpage |
          \ redraw!
  elseif has('terminal')
    command! -buffer -nargs=1 ConfigKeywordPrg
          \ silent exe 'term ' . 'env LESS= MANPAGER="less --pattern=''' . escape('\b' . <q-args> . '\b', '\') . ''' --hilite-search" man ' . b:keyword_lookup_manpage
  else
    return
  endif

  setlocal iskeyword+=- keywordprg=:ConfigKeywordPrg

  if !exists('b:undo_ftplugin') || empty(b:undo_ftplugin)
    let b:undo_ftplugin = 'setlocal keywordprg< iskeyword<  | sil! delc -buffer ConfigKeywordPrg'
  else
    let b:undo_ftplugin .= '| setlocal keywordprg< iskeyword<  | sil! delc -buffer ConfigKeywordPrg'
  endif
endfunction
