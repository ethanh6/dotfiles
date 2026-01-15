# Neovim Configuration

A modern Neovim configuration based on kickstart.nvim, migrated from NvChad v2.0 with best practices.

## Features

- 🚀 Fast startup with lazy.nvim
- 📦 Modular plugin structure
- 🎨 Multiple themes (Catppuccin, Tokyo Night, Nightfox)
- 🔍 Powerful fuzzy finding with Telescope
- 📝 LSP support for multiple languages
- ⚡ Modern completion with blink.cmp
- 🌳 Treesitter for syntax highlighting
- 🎯 Git integration (LazyGit, Gitsigns)
- 📁 Buffer-based file explorer (oil.nvim)

## Installation

1. **Backup your existing config:**
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   mv ~/.local/state/nvim ~/.local/state/nvim.backup
   mv ~/.cache/nvim ~/.cache/nvim.backup
   ```

2. **Clone this repository:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/nvim-config.git ~/.config/nvim
   ```

3. **Start Neovim:**
   ```bash
   nvim
   ```
   Plugins will install automatically on first launch.

## Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── config/
│   │   ├── options.lua      # Neovim options
│   │   ├── keymaps.lua      # Basic keymaps
│   │   └── autocmds.lua     # Autocommands
│   └── plugins/
│       ├── core/            # UI, editor, navigation plugins
│       ├── coding/          # LSP, completion, formatting
│       ├── tools/           # Git, terminal, utilities
│       └── lang/            # Language-specific plugins
└── README.md
```

## Requirements

- Neovim >= 0.10.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (optional, for icons)
- ripgrep (for Telescope live grep)
- fd (for Telescope file search)
- lazygit (for Git TUI integration)
- Node.js (for some LSP servers)
- tmux (optional, for seamless pane/window navigation)

## Tmux Integration

This config includes `vim-tmux-navigator` for seamless navigation between tmux panes and Neovim windows using `<C-h/j/k/l>`.

**Setup required**: Add tmux configuration to your `~/.tmux.conf`. See [TMUX_SETUP.md](TMUX_SETUP.md) for complete instructions.

## Key Mappings

Leader key: `<Space>`

### General
- `<leader>ww` - Close current buffer
- `<S-h>` / `<S-l>` - Previous/Next buffer
- `<C-h/j/k/l>` - Navigate between splits (tmux-aware)
- `<C-\>` - Navigate to previous split/pane (tmux-aware)
- `<Esc>` - Clear search highlights

### File Navigation
- `<leader>-` - Open oil.nvim file explorer
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers

### Git
- `<leader>gg` - Open LazyGit
- `<leader>gnh` / `<leader>gph` - Next/Previous git hunk
- `<leader>grh` - Reset git hunk
- `<leader>gpvh` - Preview git hunk

### LSP
- `gd` - Go to definition
- `gr` - Go to references
- `K` - Show hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code action
- `<leader>fm` - Format buffer

### Themes
- `<leader>aa` - Toggle between light/dark theme

## Customization

Edit files in `lua/config/` and `lua/plugins/` to customize your configuration.

## Credits

- Based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- Migrated from [NvChad](https://github.com/NvChad/NvChad) v2.0
