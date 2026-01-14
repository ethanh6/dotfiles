# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Install

```bash
git clone https://github.com/ethanh6/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

This will:
- Install dependencies via Homebrew (macOS) or apt (Linux)
- Backup any existing dotfiles
- Create symlinks using GNU Stow
- Bootstrap Neovim plugins

### Install Options

```bash
./install.sh                 # Full installation
./install.sh --packages-only # Only install packages
./install.sh --stow-only     # Only create symlinks
```

## Configs

| Package  | Description |
|----------|-------------|
| `bash`   | Bash shell configuration |
| `btop`   | btop system monitor |
| `claude` | Claude Code settings |
| `fish`   | Fish shell configuration |
| `git`    | Git configuration |
| `htop`   | htop process viewer |
| `nvim`   | Neovim - Lua-based config with Packer |
| `tmux`   | Tmux terminal multiplexer |
| `vim`    | Legacy Vim config (deprecated) |
| `zsh`    | Zsh shell with Powerlevel10k |

## Directory Structure

```
dotfiles/
├── bash/.bashrc            # → ~/.bashrc
├── btop/.config/btop/      # → ~/.config/btop
├── claude/.claude/         # → ~/.claude
├── fish/.config/fish/      # → ~/.config/fish
├── git/.gitconfig          # → ~/.gitconfig
├── htop/.config/htop/      # → ~/.config/htop
├── nvim/.config/nvim/      # → ~/.config/nvim
├── tmux/.tmux.conf         # → ~/.tmux.conf
├── vim/.vimrc              # → ~/.vimrc
├── zsh/.zshrc              # → ~/.zshrc
├── install.sh              # Installation script
├── test.sh                 # Docker test script
├── Dockerfile              # Docker test environment
└── Brewfile                # Homebrew dependencies
```

## Manual Stow Usage

Stow individual packages:

```bash
cd ~/dotfiles
stow nvim    # Symlinks ~/.config/nvim
stow bash    # Symlinks ~/.bashrc
stow git     # Symlinks ~/.gitconfig
```

Unstow (remove symlinks):

```bash
stow -D nvim
```

Restow (re-create symlinks):

```bash
stow -R nvim
```

## Dependencies

### macOS (via Homebrew)

See `Brewfile` for full list. Key packages:
- neovim, git, stow, fzf, ripgrep, fd, node, lazygit

### Linux (Debian/Ubuntu)

Installed via apt: git, stow, fzf, ripgrep, fd-find, neovim, curl

## Testing in Docker

Test the installation in an isolated environment:

```bash
./test.sh              # Build and verify all symlinks
./test.sh -i           # Interactive shell to explore
```

Or manually:

```bash
docker build -t dotfiles-test .
docker run -it --rm dotfiles-test
```

## Post-Install

1. Restart terminal or `source ~/.bashrc` (or `~/.zshrc`)
2. Open nvim and run `:PackerSync`
3. Run `:Mason` to install LSP servers
