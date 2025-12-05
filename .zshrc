# .zshrc

fpath+=("$(brew --prefix)/share/zsh/site-functions")

# This would prioritize Homebrew's binaries over system binaries...
# export PATH="/opt/homebrew/bin:$PATH"
#

# atuin
eval "$(atuin init zsh)"
autoload -U promptinit; promptinit
prompt pure

# VIM
bindkey -v

alias ll="ls -l"
alias ls="ls --color=auto"
alias doy="date -u +%j"
alias gpsweek="echo \"$((($(date +%s) - 315964800) / 604800 ))\""
alias d="devbox"
alias ds="devbox shell"

export EDITOR=nvim

# source ~/.config/zsh/aliases.zsh
# source ~/.config/zsh/functions.zsh
