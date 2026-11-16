" Set 'keywordprg' by path. BufWinEnter comes after the FileType ftplugins,
" which may set 'keywordprg' themselves.
if !has('unix')
  finish
endif

for [s:pattern, s:page] in [
      \ ['*/mpv/mpv.conf',                                      'mpv'],
      \ ['*/yt-dlp/config',                                     'yt-dlp'],
      \ ['*/youtube-dl/config',                                 'youtube-dl'],
      \ ['*/.gnupg/gpg-agent.conf',                             'gpg-agent'],
      \ ['.mbsyncrc',                                           'mbsync'],
      \ ['.msmtprc,*/.config/msmtp/config',                     'msmtp'],
      \ ['.latexmkrc,*/.config/latexmkrc,*/latexmk/latexmkrc',  'latexmk'],
      \ ['NetworkManager.conf',                                 'NetworkManager.conf'],
      \ ['.tigrc,*/.config/tig*',                               'tigrc'],
      \ ['*/ranger/rc.conf',                                    'ranger'],
      \ ['*/ranger/rifle.conf',                                 'rifle'],
      \ ['*/udiskie/config.yml',                                'udiskie'],
      \ ['*/zathura/zathurarc',                                 'zathurarc'],
      \ ['redshift.conf',                                       'redshift'],
      \ ['*/.recoll/recoll.conf',                               'recoll.conf'],
      \ ['*/thermal/thermal-conf.xml,*/thermald/thermal-conf.xml', 'thermal-conf.xml'],
      \ ['*/.imapfilter/*.lua',                                 'imapfilter_config'],
      \ ]
  execute 'autocmd filetypedetect BufWinEnter,BufFilePost' s:pattern
        \ 'call keyword_lookup#config(' . string(s:page) . ')'
endfor
unlet s:pattern s:page
