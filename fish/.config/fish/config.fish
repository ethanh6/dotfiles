# Fish shell configuration

# Disable greeting
set -g fish_greeting

# Environment variables
set -gx EDITOR nvim
set -gx VISUAL nvim

# Path additions
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin

# Homebrew (macOS)
if test -f /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

# Aliases
alias ll 'ls -alF'
alias la 'ls -A'
alias l 'ls -CF'
alias vim 'nvim'
alias v 'nvim'
alias g 'git'
alias gs 'git status'
alias gd 'git diff'
alias gc 'git commit'
alias gp 'git push'
alias gl 'git log --oneline'

# FZF integration
if type -q fzf
    fzf --fish | source
end

# NVM integration (using nvm.fish or fnm)
if test -d $HOME/.nvm
    set -gx NVM_DIR $HOME/.nvm
end

# Starship prompt (optional - uncomment if using starship)
# if type -q starship
#     starship init fish | source
# end

# Vi mode
fish_vi_key_bindings

# Colors for ls (if using GNU coreutils)
if type -q dircolors
    eval (dircolors -c)
end
