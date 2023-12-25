#  common options
export LANG=en_US.UTF-8
export HIST_STAMPS="yyyy-mm-dd"
export PATH="$PATH:$HOME/.local/bin"
export EDITOR="vim"

unsetopt PROMPT_SP
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"


[ -d $XDG_CONFIG_HOME/zsh/plugins/zsh-autosuggestions ] || \
  git clone https://github.com/zsh-users/zsh-autosuggestions $XDG_CONFIG_HOME/zsh/plugins/zsh-autosuggestions
[ -d $XDG_CONFIG_HOME/zsh/plugins/fast-syntax-highlighting ] || \
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting $XDG_CONFIG_HOME/zsh/plugins/fast-syntax-highlighting

# Set theme
autoload -U colors && colors && PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
# Enable plugins
source $XDG_CONFIG_HOME/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
source $XDG_CONFIG_HOME/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 2>/dev/null

setopt autocd		# Automatically cd into typed directory.
setopt autopushd
# Automatically pushd everytime before using cd.
# Type cd -<Enter> to view dir stack
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="$XDG_CACHE_HOME/zshistory"

# Load aliases
[ -f "$XDG_CONFIG_HOME/aliasrc" ] && source "$XDG_CONFIG_HOME/aliasrc"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
# Case insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}

zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

mkcd () { mkdir "$1" && cd "$1" }

bindkey -s '^v' '^unvim\n'
bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n' # find file in cwd using fzf

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete

# Switch escape and caps if tty and no passwd required:
sudo -n loadkeys $XDG_DATA_HOME/ttymaps.kmap 2>/dev/null
