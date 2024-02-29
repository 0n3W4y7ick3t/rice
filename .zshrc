###             *** Leon Akashiya's zshrc ***             ###
### https://github.com/0n3W4y7ick3t/rice/blob/main/.zshrc ###

# *** Install powerlevel10k theme and plugins if not present  ***
# You can remove these lines after they are installed.
[ -d $XDG_CONFIG_HOME/zsh/themes/powerlevel10k ] || \
  git clone --depth=1 https://github.com/romkatv/powerlevel10k $XDG_CONFIG_HOME/zsh/themes/powerlevel10k
[ -d $XDG_CONFIG_HOME/zsh/plugins/zsh-autosuggestions ] || \
  git clone https://github.com/zsh-users/zsh-autosuggestions $XDG_CONFIG_HOME/zsh/plugins/zsh-autosuggestions
[ -d $XDG_CONFIG_HOME/zsh/plugins/fast-syntax-highlighting ] || \
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting $XDG_CONFIG_HOME/zsh/plugins/fast-syntax-highlighting

# Set theme
# autoload -U colors && colors && PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
source $XDG_CONFIG_HOME/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme
# Enable plugins
source $XDG_CONFIG_HOME/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
source $XDG_CONFIG_HOME/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 2>/dev/null

setopt autocd
# Automatically cd into typed directory.
setopt autopushd
# Automatically pushd everytime before using cd.
# Type cd -<Enter> to view dir stack
setopt interactive_comments

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
# Case insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
fpath+=~/.zfunc
autoload -U compinit && compinit
zmodload zsh/complist
_comp_options+=(globdots) # Include hidden files.

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
bmf () { echo "$1" `realpath $2` >> $XDG_CONFIG_HOME/shell/bm-files && shortcuts} # add file to files bookmark
bmd () { echo "$1" `realpath .` >> $XDG_CONFIG_HOME/shell/bm-dirs && shortcuts }   # add current dir to dirs bookmark

bindkey -s '^o' '^ulfcd\n'                     # open lf file browser
bindkey -s '^v' '^unvim\n'                     # gimee neovim!
bindkey -s '^n' '^uneofetch\n'                 # typical arch users be like...
bindkey -s '^a' '^ubc -lq\n'                   # caculator
bindkey -s '^g' '^ulazygit\n'                  # lazier everyday!
bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n' # find file in cwd using fzf
bindkey -s '^r' '!!\n'                         # redo last command
bindkey -s '^k' '^ucode . &> /dev/null &\n'    # nahaha

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete
