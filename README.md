This Vim plug-in sets `&keywordprg` (see `:help K`) so that hitting the key `K` shows the documentation of the keyword under the cursor in common (`Unix`) configuration files, for example `~/.inputrc` and `Git`.

If the passage shown in the manpage is not to the point, please hit `n` a few times till reaching the most relevant one.

To look up the current keyword in many file types by the graphical offline documentation browser [Zeal](http://www.zealdocs.org) as well, have a look at [vim-zeal](https://github.com/Konfekt/vim-zeal).

# Supported files

| File | Manpage |
| --- | --- |
| Git config files (file type `gitconfig`) | `git-config`, at the key of the current section |
| `mpv/mpv.conf` | `mpv` |
| `yt-dlp/config` | `yt-dlp` |
| `youtube-dl/config` | `youtube-dl` |
| `~/.gnupg/gpg-agent.conf` | `gpg-agent` |
| `~/.mbsyncrc` | `mbsync` |
| `~/.msmtprc`, `~/.config/msmtp/config` | `msmtp` |
| `~/.latexmkrc`, `latexmk/latexmkrc` | `latexmk` |
| `NetworkManager.conf` | `NetworkManager.conf` |
| `~/.tigrc`, `~/.config/tig/config` | `tigrc` |
| `ranger/rc.conf` | `ranger` |
| `ranger/rifle.conf` | `rifle` |
| `udiskie/config.yml` | `udiskie` |
| `zathura/zathurarc` | `zathurarc` |
| `redshift.conf` | `redshift` |
| `~/.recoll/recoll.conf` | `recoll.conf` |
| `thermald/thermal-conf.xml` | `thermal-conf.xml` |
| `~/.imapfilter/*.lua` | `imapfilter_config` |

The manpage opens in `less`: by `:!` in terminal Vim, and in a `:terminal` in GVim and Neovim.

# Tests

Run `test/run.sh [vim] [nvim]` to run the headless tests in Vim and Neovim; they use a stand-in for `man`.
