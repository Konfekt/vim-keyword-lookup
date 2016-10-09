if executable('sman')
  setlocal keywordprg=sman\ muttrc
  if empty(maparg('K', 'n')) | nnoremap <buffer> K K<CR> | endif
  if empty(maparg('K', 'x')) | xnoremap <buffer> K K<CR> | endif
endif
