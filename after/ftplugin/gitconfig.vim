" Sourced after the runtime ftplugin, which overwrites b:undo_ftplugin.
if !keyword_lookup#available()
  finish
endif

command! -buffer -nargs=1 GitKeywordPrg
      \ call keyword_lookup#man('git-config', '^\s{0,8}' . keyword_lookup#gitconfig_section() . <q-args> . '\b')
call keyword_lookup#set('GitKeywordPrg')
