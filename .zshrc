# .zshrc

# atuin
eval "$(atuin init zsh --disable-up-arrow)"

# Prompt theme
autoload -U promptinit; promptinit
prompt pure

# VIM
bindkey -v

# Aliases
alias ll="ls -l"
alias ls="ls --color=auto"
alias doy="date -u +%j"
alias gpsweek="echo \"$((($(date +%s) - 315964800) / 604800 ))\""
alias d="devbox"
alias ds="devbox shell"
alias k="kubectl"
alias z="zellij"
alias eval-ssh='eval $(ssh-agent -s) && ssh-add'
alias summarize="claude \"summarize and review the uncommitted changes. See any issues? have any questions?\""

# 
export EDITOR=nvim

#
# Functions
#
# Yank to the system clipboard
function vi-yank-xclip {
    zle vi-yank
   echo -n "$CUTBUFFER" | pbcopy
}

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

# source ~/.config/zsh/aliases.zsh
# source ~/.config/zsh/functions.zsh

