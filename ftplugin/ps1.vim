" Look up keywords by Get-Help:
" check for PowerShell Core in Windows, Linux or MacOS
if executable('pwsh') | let s:pwsh_cmd = 'pwsh'
" on Windows Subsystem for Linux, check for PowerShell Core in Windows
elseif exists('$WSLENV') && executable('pwsh.exe') | let s:pwsh_cmd = 'pwsh.exe'
" check for PowerShell <= 5.1 in Windows
elseif executable('powershell.exe') | let s:pwsh_cmd = 'powershell.exe'
endif

if exists('s:pwsh_cmd')
  if executable('less') && !has('gui_running') &&
        \ !(exists('$ConEmuBuild') && &term =~? '^xterm')
    command! -buffer -nargs=1 GetHelp silent exe '!' . s:pwsh_cmd . ' -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command Get-Help -Full "<args>" | ' . (has('unix') ? 'LESS= LESSOPEN= less' : 'less') | redraw!
  elseif has('terminal')
    command! -buffer -nargs=1 GetHelp silent exe 'term ' . s:pwsh_cmd . ' -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command Get-Help -Full "<args>"' . ' | ' . (executable('less') ? (has('unix') ? 'env LESS= LESSOPEN= less' : 'less') : '')
  else
    command! -buffer -nargs=1 GetHelp echo system(s:pwsh_cmd . ' -NoLogo -NoProfile -NonInteractive -ExecutionPolicy RemoteSigned -Command Get-Help -Full <args>')
  endif
endif
setlocal keywordprg=:GetHelp

let g:loaded_ps1 = 1
