#!/bin/sh
# Run the headless tests in Vim and Neovim: test/run.sh [vim] [nvim]
set -eu
root=$(cd "$(dirname "$0")/.." && pwd)
PATH=$root/test/bin:$PATH
export PATH
vim=${1:-vim}
nvim=${2:-nvim}
status=0
# Load the plugin before $VIMRUNTIME, as plugin managers do.
setup="set nocompatible rtp^=$root rtp+=$root/after | filetype plugin on"

run() {
  name=$1
  shift
  if out=$("$@" 2>&1); then
    printf '%s: %s\n' "$name" "$out"
  else
    printf '%s:\n%s\n' "$name" "$out"
    status=1
  fi
}

if command -v "$vim" >/dev/null 2>&1; then
  run vim "$vim" -N -u NONE -i NONE -n -es --cmd "$setup" -S "$root/test/test.vim"
else
  echo "vim: not found, skipped"
fi
if command -v "$nvim" >/dev/null 2>&1; then
  run nvim "$nvim" --clean --headless -n --cmd "$setup" -S "$root/test/test.vim"
else
  echo "nvim: not found, skipped"
fi
exit $status
