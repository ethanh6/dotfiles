# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository managed with GNU Stow, primarily focused on Neovim with a modular Lua-based setup using Packer as the plugin manager.

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

Entry point: `nvim/.config/nvim/init.lua` - requires all modules in sequence

Modules in `nvim/.config/nvim/lua/user/`:
- `plugins.lua` - Packer plugin specifications (source of truth)
- `options.lua` - Editor settings (2-space tabs, relative line numbers, clipboard)
- `keymaps.lua` - Global key mappings (leader = Space)
- `lsp/init.lua` - Mason LSP manager setup
- `lsp/handlers.lua` - LSP keymaps and diagnostic styling
- `lsp/null-ls.lua` - Formatters and linters
- Individual plugin configs: `telescope.lua`, `cmp.lua`, `treesitter.lua`, etc.

**Plugin Management:**
```vim
:PackerSync      " Install/update/compile plugins
:PackerCompile   " Regenerate packer_compiled.lua
:TSUpdate        " Update treesitter parsers
:Mason           " Manage LSP servers
```

## Key Mappings

- **Leader**: Space
- **Window nav**: Ctrl-h/j/k/l
- **Buffer switch**: Shift-h/l
- **File finder**: `<leader>ff`
- **Live grep**: `<leader>fg`
- **File tree**: `<leader>tt`
- **Terminal**: Ctrl-\
- **Format**: `<leader>format`

## Custom Terminals (toggleterm)

Functions defined in `toggleterm.lua`:
- `_LAZYGIT_TOGGLE()`, `_PYTHON_TOGGLE()`, `_NODE_TOGGLE()`, `_HTOP_TOGGLE()`, `_NCDU_TOGGLE()`

## LSP Servers

Managed via Mason. Configured in `lsp/init.lua`:
- `sumneko_lua`, `rust_analyzer`

Formatters/linters via null-ls: `prettier`, `black`, `stylua`, `clang_format`, `eslint`, `flake8`

## Bash Integrations

`bash/.bashrc` sources: FZF, NVM, Conda, Cargo

## Notes

- `packer_compiled.lua` is auto-generated
- Colorscheme set in `colorscheme.lua` (currently nightfox)
- "Undefined global vim" warnings in Lua files are expected (vim is a Neovim runtime global)
