if !has('unix')
  finish
endif

au BufRead,BufNewFile,BufFilePost */zathura/zathurarc        call s:keywordprg('zathurarc')
au BufRead,BufNewFile,BufFilePost .tigrc                     call s:keywordprg('tigrc')
au BufRead,BufNewFile,BufFilePost .latexmkrc                 call s:keywordprg('latexmk')
au BufRead,BufNewFile,BufFilePost .mbsyncrc                  call s:keywordprg('mbsync')
au BufRead,BufNewFile,BufFilePost .inputrc                  call s:keywordprg('3 readline')

au BufRead,BufNewFile,BufFilePost */ranger/rc.conf           call s:keywordprg('ranger')
au BufRead,BufNewFile,BufFilePost */ranger/rifle.conf        call s:keywordprg('rifle')
au BufRead,BufNewFile,BufFilePost redshift.conf              call s:keywordprg('redshift')
au BufRead,BufNewFile,BufFilePost */.recoll/recoll.conf      call s:keywordprg('recoll.conf')
au BufRead,BufNewFile,BufFilePost */.gnupg/gpg-agent.conf    call s:keywordprg('gpg-agent')
au BufRead,BufNewFile,BufFilePost */thermal/thermal-conf.xml call s:keywordprg('thermal-conf.xml')
au BufRead,BufNewFile,BufFilePost */.imapfilter/*.lua        call s:keywordprg('imapfilter_config')

au FileType muttrc    call s:keywordprg('muttrc')
au FileType msmtp     call s:keywordprg('msmtp')
au FileType gitconfig call s:keywordprg('git-config')
au FileType gpg       call s:keywordprg('gpg')
au FileType sshconfig call s:keywordprg('ssh_config')
au FileType zsh       call s:keywordprg('zshall')
au FileType sh        call s:keywordprg('bash')

function! s:keywordprg(man)
  let b:man = a:man
  command! -buffer -nargs=1 Sman 
        \ silent exe '!' . 'MANPAGER="less --pattern=''\b' . <q-args> . '\b'' --hilite-search --squeeze-blank-lines" man ' . b:man |
        \ redraw!
  setlocal iskeyword+=-
  setlocal keywordprg=:Sman
endfunction
