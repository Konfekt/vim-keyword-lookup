if !executable('sman') && !empty(findfile('macros/sman', &rtp))
  let $PATH=fnamemodify(findfile('macros/sman', &rtp),':p:h'). ':' . $PATH
endif

