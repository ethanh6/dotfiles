#!/usr/bin/env bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*) OS="macos" ;;
        Linux*)  OS="linux" ;;
        *)       error "Unsupported OS: $(uname -s)" ;;
    esac
    info "Detected OS: $OS"
}

# Install Homebrew (macOS and Linux)
install_homebrew() {
    # Add brew to PATH if it exists but isn't in PATH
    if ! command -v brew &> /dev/null; then
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            # macOS Apple Silicon
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f "/usr/local/bin/brew" ]]; then
            # macOS Intel
            eval "$(/usr/local/bin/brew shellenv)"
        elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
            # Linux
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
    fi

    # Install Homebrew if still not found
    if ! command -v brew &> /dev/null; then
        info "Installing Homebrew..."

        # Install build dependencies on Linux
        if [[ "$OS" == "linux" ]]; then
            info "Installing Homebrew dependencies..."
            sudo apt-get update
            sudo apt-get install -y build-essential procps curl file git
        fi

        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add to PATH after installation
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
    else
        info "Homebrew already installed"
    fi
}

# Install packages via Homebrew (macOS)
install_macos_packages() {
    info "Installing packages via Homebrew..."

    if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
        brew bundle --file="$DOTFILES_DIR/Brewfile"
    else
        # Fallback if no Brewfile
        brew install git neovim stow fzf ripgrep fd node
    fi
}

# Install packages via Homebrew (Linux)
install_linux_packages() {
    info "Installing packages via Homebrew..."

    if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
        brew bundle --file="$DOTFILES_DIR/Brewfile"
    else
        # Fallback if no Brewfile
        brew install git neovim stow fzf ripgrep fd node
    fi
}

# Install packages based on OS
install_packages() {
    install_homebrew
    case "$OS" in
        macos)
            install_macos_packages
            ;;
        linux)
            install_linux_packages
            ;;
    esac
}

# Backup existing dotfiles
backup_existing() {
    local backup_dir="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
    local needs_backup=false

    # Check what needs backing up
    local files_to_check=(
        "$HOME/.bashrc"
        "$HOME/.gitconfig"
        "$HOME/.config/nvim"
        "$HOME/.vim"
        "$HOME/.vimrc"
    )

    for file in "${files_to_check[@]}"; do
        if [[ -e "$file" && ! -L "$file" ]]; then
            needs_backup=true
            break
        fi
    done

    if [[ "$needs_backup" == true ]]; then
        info "Backing up existing dotfiles to $backup_dir"
        mkdir -p "$backup_dir"

        for file in "${files_to_check[@]}"; do
            if [[ -e "$file" && ! -L "$file" ]]; then
                mv "$file" "$backup_dir/" 2>/dev/null || true
            fi
        done
    fi
}

# Remove existing symlinks
clean_symlinks() {
    info "Cleaning existing symlinks..."

    local symlinks=(
        "$HOME/.bashrc"
        "$HOME/.gitconfig"
        "$HOME/.config/nvim"
        "$HOME/.vim"
        "$HOME/.vimrc"
    )

    for link in "${symlinks[@]}"; do
        if [[ -L "$link" ]]; then
            rm "$link"
        fi
    done
}

# Create symlinks using GNU Stow
stow_packages() {
    info "Creating symlinks with GNU Stow..."

    cd "$DOTFILES_DIR"

    # Stow each package (all available)
    local packages=(bash btop ccusage claude fish git htop nvim tmux vim zsh)

    for pkg in "${packages[@]}"; do
        if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
            info "Stowing $pkg..."
            stow -v -R -t "$HOME" "$pkg"
        else
            warn "Package $pkg not found, skipping"
        fi
    done
}

# Setup Neovim plugins
setup_neovim() {
    info "Setting up Neovim plugins..."

    # lazy.nvim auto-installs plugins on first run
    if command -v nvim &> /dev/null; then
        nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
        info "Neovim plugins installed (lazy.nvim auto-installs on first run)"
    fi
}

# Setup FZF keybindings
setup_fzf() {
    if command -v brew &> /dev/null && [[ -f "$(brew --prefix)/opt/fzf/install" ]]; then
        info "Setting up FZF..."
        "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-zsh
    fi
}

# Print summary
print_summary() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  Installation Complete!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "Installed packages and created symlinks for:"
    echo "  - bash (~/.bashrc)"
    echo "  - btop (~/.config/btop)"
    echo "  - ccusage (~/.config/ccusage)"
    echo "  - claude (~/.claude)"
    echo "  - fish (~/.config/fish)"
    echo "  - git (~/.gitconfig, ~/.config/git)"
    echo "  - htop (~/.config/htop)"
    echo "  - nvim (~/.config/nvim)"
    echo "  - tmux (~/.tmux.conf, ~/.tmux)"
    echo "  - vim (~/.vimrc, ~/.vim)"
    echo "  - zsh (~/.zshrc, ~/.zshenv, ~/.zprofile, ~/.p10k.zsh)"
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
    echo "  2. Open nvim - lazy.nvim will auto-install plugins on first run"
    echo "  3. Run :Mason in nvim to install LSP servers"
    echo ""
}

# Main
main() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║       Dotfiles Installation Script     ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""

    detect_os
    install_packages
    backup_existing
    clean_symlinks
    stow_packages
    setup_neovim
    setup_fzf
    print_summary
}

# Run with options
case "${1:-}" in
    --packages-only)
        detect_os
        install_packages
        ;;
    --stow-only)
        backup_existing
        clean_symlinks
        stow_packages
        ;;
    --help|-h)
        echo "Usage: $0 [option]"
        echo ""
        echo "Options:"
        echo "  (none)           Full installation"
        echo "  --packages-only  Only install packages"
        echo "  --stow-only      Only create symlinks"
        echo "  --help           Show this help"
        ;;
    *)
        main
        ;;
esac
