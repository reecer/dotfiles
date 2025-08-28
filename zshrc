set -o vi

# ---- completion system ----
autoload -Uz compinit
compinit

# ---- prompt ----
autoload -U promptinit; promptinit
if type pure > /dev/null 2>&1; then
  prompt pure
else
    echo "pure is not installed"
fi

# ---- aliases ----
# ls colors
alias ls='ls --color=auto'

# DOY (Julian Day)
alias doy='date +%j'

# GPS Week
alias gpsweek='echo "$(( ($(date +%s) - 315964800) / 604800 ))"'
