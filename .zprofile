#!/bin/zsh
# profile file. Runs on login. Environmental variables are set here.

export MAKEFLAGS="-j $(grep processor /proc/cpuinfo | wc -l)"
export LANG=en_US.UTF-8
export TIME_STYLE='+%y/%m/%d %H:%M:%S'
export HIST_STAMPS="yyyy-mm-dd"

unsetopt PROMPT_SP

# Default programs:
export EDITOR="nvim"

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export LESSHISTFILE="-"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"
export PYTHON_VENV_DIR=$HOME/.local/share/pyenv

# Other program settings:
export DICS="/usr/share/stardict/dic/"
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
export QT_QPA_PLATFORMTHEME="gtk2"         # Have QT use gtk2 theme.
export MOZ_USE_XINPUT2="1"                 # Mozilla smooth scrolling/touchpads.
export AWT_TOOLKIT="MToolkit wmname LG3D"  # May have to install wmname
export _JAVA_AWT_WM_NONREPARENTING=1       # Fix for Java applications in dwm

export PATH=$PATH:$HOME/.scripts:$CARGO_HOME/bin:$GOPATH/bin

[ ! -f $XDG_CONFIG_HOME/shell/shortcutrc ] && shortcuts >/dev/null 2>&1 &

# Switch escape and caps if tty and no passwd required:
sudo -n loadkeys $XDG_CONFIG_HOME/ttymaps.kmap 2>/dev/null
