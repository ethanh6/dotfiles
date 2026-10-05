# OrbStack shell integration (docker CLI, etc.)
[ -f "$HOME/.orbstack/shell/init.zsh" ] && source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null

eval "$(/opt/homebrew/bin/brew shellenv)"
