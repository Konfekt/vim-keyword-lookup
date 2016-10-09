if !executable('sman')
  finish
endif

au BufRead,BufNewFile,BufFilePost {.?zathura,.tig,.latexmk,.mbsync}rc,,{redshift,recoll,gpg}.conf
      \ setlocal filetype=conf |
      \ call s:keywordprg()

function! s:keywordprg()
  if empty(maparg('K', 'n')) | nnoremap <buffer> K K<CR> | endif
  if empty(maparg('K', 'x')) | xnoremap <buffer> K K<CR> | endif
  setlocal iskeyword+=-

  if expand('<afile>:t') =~# '\v^\.?zathurarc$'
    setlocal keywordprg=sman\ zathurarc
  elseif expand('<afile>:t') ==# '.tigrc'
    setlocal keywordprg=sman\ tigrc
  elseif expand('<afile>:t') ==# '.latexmkrc'
    setlocal keywordprg=sman\ latexmk
  elseif expand('<afile>:t') ==# '.mbsyncrc'
    setlocal keywordprg=sman\ mbsync
  elseif expand('<afile>:t') ==# 'redshift.conf'
    setlocal keywordprg=sman\ redshift
  elseif expand('<afile>:t') ==# 'recoll.conf'
    setlocal keywordprg=sman\ recoll.conf
  elseif expand('<afile>:t') ==# 'gpg.conf'
    setlocal keywordprg=sman\ gpg
  endif
endfunction
