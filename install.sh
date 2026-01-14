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

# Install Homebrew (macOS)
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add to PATH for Apple Silicon
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
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

# Install packages via apt (Debian/Ubuntu)
install_linux_packages() {
    info "Installing packages via apt..."

    sudo apt update
    sudo apt install -y \
        git \
        stow \
        fzf \
        ripgrep \
        fd-find \
        curl \
        build-essential

    # Neovim - install latest stable from PPA or AppImage
    if ! command -v nvim &> /dev/null; then
        info "Installing Neovim..."
        # Try PPA first (Ubuntu)
        if command -v add-apt-repository &> /dev/null; then
            sudo add-apt-repository -y ppa:neovim-ppa/stable
            sudo apt update
            sudo apt install -y neovim
        else
            # Fallback to AppImage
            curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
            chmod u+x nvim.appimage
            sudo mv nvim.appimage /usr/local/bin/nvim
        fi
    fi

    # Node.js via nvm
    if ! command -v node &> /dev/null; then
        info "Installing Node.js via nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm install --lts
    fi
}

# Install packages based on OS
install_packages() {
    case "$OS" in
        macos)
            install_homebrew
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

    # Stow each package
    local packages=(bash git nvim vim)

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

    # Packer bootstrap - it auto-installs on first run
    # Just run PackerSync headlessly
    if command -v nvim &> /dev/null; then
        nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' 2>/dev/null || true
        info "Neovim plugins installed (run :PackerSync manually if issues occur)"
    fi
}

# Setup FZF keybindings
setup_fzf() {
    if [[ "$OS" == "macos" ]] && [[ -f "$(brew --prefix)/opt/fzf/install" ]]; then
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
    echo "  - git (~/.gitconfig)"
    echo "  - nvim (~/.config/nvim)"
    echo "  - vim (~/.vimrc, ~/.vim)"
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.bashrc"
    echo "  2. Open nvim and run :PackerSync if plugins didn't install"
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
