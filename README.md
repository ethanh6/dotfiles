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

| Package | Description |
|---------|-------------|
| `nvim`  | Neovim - Lua-based config with Packer |
| `bash`  | Bash shell configuration |
| `git`   | Git configuration |
| `vim`   | Legacy Vim config (deprecated) |

## Directory Structure

```
dotfiles/
├── nvim/.config/nvim/   # → ~/.config/nvim
├── bash/.bashrc         # → ~/.bashrc
├── git/.gitconfig       # → ~/.gitconfig
├── vim/.vimrc           # → ~/.vimrc
├── vim/.vim/            # → ~/.vim
├── install.sh           # Installation script
└── Brewfile             # Homebrew dependencies
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

## Post-Install

1. Restart terminal or `source ~/.bashrc`
2. Open nvim and run `:PackerSync`
3. Run `:Mason` to install LSP servers

## Todo

- [ ] Migrate to zsh / oh-my-zsh
- [ ] Add tmux configuration
