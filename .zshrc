# .zshrc
autoload -U promptinit; promptinit
prompt pure

bindkey -v


fpath+=("$(brew --prefix)/share/zsh/site-functions")
