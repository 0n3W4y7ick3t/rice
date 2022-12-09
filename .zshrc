# install themes if not exist
[ -z $XDG_CONFIG_HOME/zsh/powerlevel10k ] && git clone https://github.com/romkatv/powerlevel10k.git $XDG_CONFIG_HOME/zsh/powerlevel10k
[ -z $XDG_CONFIG_HOME/zsh/agnoster-zsh-theme ] && git clone https://github.com/agnoster/agnoster-zsh-theme $XDG_CONFIG_HOME/zsh/agnoster-zsh-theme

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors

# Select theme
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
# source $XDG_CONFIG_HOME/zsh/agnoster-zsh-theme/agnoster.zsh-theme
# source $XDG_CONFIG_HOME/zsh/powerlevel10k/powerlevel10k.zsh-theme


setopt autocd		# Automatically cd into typed directory.
setopt autopushd
# automatically pushd everytime before using cd.
# type cd -<Enter> to view dir stack
setopt interactive_comments
setopt prompt_subst # for loading theme files

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="$XDG_CACHE_HOME/zshistory"

# Load aliases and shortcuts if existent.
[ -f "$XDG_CONFIG_HOME/shell/shortcutrc" ] && source "$XDG_CONFIG_HOME/shell/shortcutrc"
[ -f "$XDG_CONFIG_HOME/shell/aliasrc" ] && source "$XDG_CONFIG_HOME/shell/aliasrc"
[ -f "$XDG_CONFIG_HOME/shell/zshnameddirrc" ] && source "$XDG_CONFIG_HOME/shell/zshnameddirrc"

# Basic auto/tab complete:
zstyle ':completion:*' menu select
# case insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -U compinit && compinit
zmodload zsh/complist
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

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

mkcd () { mkdir "$1" && cd "$1" }

wd () {
    . /usr/share/wd/wd.sh
}

# more info, check https://github.com/dutchcoders/transfer.sh/blob/main/examples.md
transfer() {
    wget -t 1 -qO - --method=PUT --body-file="$1" --header="Content-Type: $(file -b --mime-type "$1")" https://transfer.sh/$(basename "$1");
    echo
}

bindkey -s '^o' '^ulfcd\n'

bindkey -s '^v' '^unvim\n'

bindkey -s '^a' '^ubc -lq\n'

bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete

source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 2>/dev/null
