# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository managed with GNU Stow, primarily focused on Neovim with a modular Lua-based setup using lazy.nvim as the plugin manager.

## Installation

```bash
git clone https://github.com/ethanh6/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

Options: `--packages-only` (install deps only), `--stow-only` (symlinks only)

## Testing in Docker

Test the installation script in an isolated environment:

```bash
./test.sh              # Build and verify symlinks
./test.sh -i           # Interactive shell to explore
```

Or manually:

```bash
docker build -t dotfiles-test .
docker run -it --rm dotfiles-test
```

## Repository Structure

```
bash/.bashrc              # Bash config
btop/.config/btop/        # btop config
ccusage/.config/ccusage/  # ccusage CLI config
claude/.claude/           # Claude Code settings
fish/.config/fish/        # Fish shell config
git/.gitconfig            # Git config
git/.config/git/          # Git ignore patterns
htop/.config/htop/        # htop config
nvim/.config/nvim/        # Neovim config
tmux/.tmux.conf           # Tmux config
vim/.vimrc                # Legacy Vim (deprecated)
zsh/.zshrc                # Zsh config + p10k theme
install.sh                # Installation script
test.sh                   # Docker test script
Dockerfile                # Docker test environment
Brewfile                  # Homebrew dependencies
.stow-local-ignore        # Files to exclude from stowing
```

## Stow Commands

```bash
stow nvim              # Create symlink
stow -D nvim           # Remove symlink
stow -R nvim           # Re-create symlink
```

## Neovim Architecture

Entry point: `nvim/.config/nvim/init.lua` - bootstraps lazy.nvim and loads config

Structure in `nvim/.config/nvim/lua/`:
- `config/options.lua` - Editor settings (relative numbers, scrolloff, etc.)
- `config/keymaps.lua` - Core keymaps and buffer management
- `config/autocmds.lua` - Autocommands (YAML folding, auto-resize)
- `plugins/core/` - UI, editor, navigation, oil.nvim
- `plugins/coding/` - LSP, completion (blink.cmp), formatting (conform.nvim), copilot
- `plugins/tools/` - Git (lazygit, gitsigns)
- `plugins/lang/` - Treesitter

**Plugin Management:**
```vim
:Lazy            " Open lazy.nvim UI
:Lazy sync       " Install/update plugins
:Mason           " Manage LSP servers
```

## Key Mappings

- **Leader**: Space
- **Window nav**: Ctrl-h/j/k/l
- **Buffer switch**: Shift-h/l
- **File finder**: `<leader>ff`
- **Live grep**: `<leader>fg`
- **File explorer**: `<leader>-` (oil.nvim)
- **LazyGit**: `<leader>gg`
- **Format**: `<leader>fm`
- **Theme toggle**: `<leader>aa`

## LSP Servers

Managed via Mason (17 servers configured):
- Web: html, cssls, ts_ls, jsonls
- Systems: clangd, gopls, pyright
- Config: yamlls, jsonnet_ls, lua_ls, bashls

Formatters via conform.nvim: `prettier`, `stylua`, `clang-format`, `shfmt`

## Notes

- Neovim >= 0.10.0 required
- Colorscheme: Catppuccin (dark) / Everforest (light)
- "Undefined global vim" warnings in Lua files are expected (vim is a Neovim runtime global)
- See `nvim/.config/nvim/CLAUDE.md` for detailed nvim documentation
