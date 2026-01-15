# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a **kickstart.nvim-based** Neovim configuration with modular plugin organization. Migrated from NvChad v2.0 with modern best practices and zero deprecated APIs.

### Directory Structure

```
~/.config/nvim/
├── init.lua                 # Entry point with lazy.nvim bootstrap
├── lua/
│   ├── config/
│   │   ├── options.lua      # Neovim settings (relative numbers, scrolloff, etc.)
│   │   ├── keymaps.lua      # Core keymaps and buffer management
│   │   └── autocmds.lua     # Autocommands (YAML folding, auto-resize)
│   │
│   └── plugins/
│       ├── core/            # Essential UI and editor plugins
│       │   ├── ui.lua       # Themes, which-key, indent-blankline
│       │   ├── editor.lua   # Comment, surround, vim-sleuth, autopairs
│       │   ├── navigation.lua # Telescope with fzf and live-grep-args
│       │   └── oil.lua      # Oil.nvim file explorer
│       │
│       ├── coding/          # Code-related functionality
│       │   ├── lsp.lua      # Mason + nvim-lspconfig (17 LSP servers)
│       │   ├── completion.lua # blink.cmp + autopairs
│       │   ├── formatting.lua # conform.nvim with 5 formatters
│       │   └── copilot.lua  # GitHub Copilot (copilot.lua)
│       │
│       ├── tools/           # Development tools
│       │   └── git.lua      # LazyGit + Gitsigns
│       │
│       └── lang/            # Language-specific plugins
│           └── treesitter.lua # 18 language parsers
│
├── README.md                # Installation and usage guide
└── CLAUDE.md                # This file
```

## Plugin Organization Philosophy

### Modular by Purpose
- **core/**: Essential UI, editor enhancements, and navigation
- **coding/**: LSP, completion, formatting, AI assistance
- **tools/**: Git, terminal, Docker, etc.
- **lang/**: Language-specific features (treesitter, go.nvim, etc.)

### Lazy Loading Strategy
- Event-based: `BufReadPost`, `BufNewFile`, `InsertEnter`
- Command-based: `cmd = { "Mason", "LazyGit" }`
- Keymap-driven: `keys = { { "<leader>gg", ... } }`
- Critical plugins: `lazy = false` (blink.cmp, catppuccin)

## Core Configuration

### Themes
**Primary**: Catppuccin (mocha flavor)
**Light mode**: Everforest (soft background)
**Alternatives**: Tokyo Night (night style), Nightfox

**Toggle**: `<leader>aa` switches between catppuccin and everforest

### LSP Servers (17)
Configured via Mason with automatic installation:
- **Web**: html, cssls, ts_ls, jsonls
- **Systems**: clangd
- **Scripting**: bashls, pyright
- **Config**: yamlls (with K8s/GitHub/Docker schemas), jsonnet_ls, bzl
- **Go**: gopls (with staticcheck and gofumpt)
- **Neovim**: lua_ls, vimls

**Custom configurations**:
- `lua_ls`: Vim runtime, lazy.nvim types
- `yamlls`: JSON schemas for GitHub workflows, Kubernetes, Docker Compose
- `gopls`: Static analysis, unused params detection
- `ts_ls`: Suggestion preferences

### Formatters (via conform.nvim)
- **Lua**: stylua
- **JS/TS/CSS/HTML/JSON/YAML**: prettier, prettierd
- **C/C++**: clang-format
- **Shell**: shfmt

**Format on save**: Enabled (except C/C++)
**Manual format**: `<leader>fm`

### Completion (blink.cmp)
- **Sources**: LSP, path, snippets, buffer
- **Keymap preset**: "default" (Tab/S-Tab navigate, Enter accepts)
- **Signature help**: Enabled
- **Autopairs**: Integrated via nvim-autopairs

## Key Mappings

### Leader Key
`<Space>` (must be set before plugins load)

### Core Navigation
| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate splits |
| `<S-h>` / `<S-l>` | Previous/Next buffer |
| `<leader>ww` | Close current buffer |
| `<leader>bd` | Close all buffers except current |
| `<Esc>` | Clear search highlights |

### File Finding (Telescope)
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fw` | Live grep with args (advanced) |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Find help |
| `<leader>fk` | Find keymaps |
| `<leader>fcmd` | Find commands |
| `<leader>fgc` | Git commits |
| `<leader>fgt` | Git status |
| `<leader>/` | Fuzzy find in current buffer |
| `<leader>fn` | Find Neovim config files |

### File Explorer (oil.nvim)
| Key | Action |
|-----|--------|
| `<leader>-` | Open oil.nvim |
| `<CR>` | Select file/directory |
| `<C-s>` | Open in vsplit |
| `<C-h>` | Open in hsplit |
| `<C-p>` | Preview |
| `-` | Go to parent directory |
| `g.` | Toggle hidden files |
| `q` | Close oil (safe, won't quit Neovim) |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gD` | Go to declaration |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>D` | Type definition |
| `<leader>ds` | Document symbols |
| `<leader>ws` | Workspace symbols |
| `<leader>th` | Toggle inlay hints |

### Git
| Key | Action |
|-----|--------|
| `<leader>gg` | Open LazyGit |
| `<leader>gnh` / `<leader>gph` | Next/Previous hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghp` | Preview hunk |
| `<leader>ghb` | Blame line |
| `<leader>gtb` | Toggle blame line |
| `<leader>gtd` | Toggle deleted |

### Editor Enhancement
| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gc` (visual) | Toggle comment |
| `ys{motion}{char}` | Add surrounding |
| `ds{char}` | Delete surrounding |
| `cs{target}{replacement}` | Change surrounding |
| `<A-j>` / `<A-k>` | Move line up/down |
| `<` / `>` (visual) | Indent and reselect |

### GitHub Copilot
| Key | Action |
|-----|--------|
| `<C-l>` | Accept suggestion |
| `<M-]>` / `<M-[>` | Next/Previous suggestion |
| `<C-]>` | Dismiss suggestion |
| `<M-CR>` | Open Copilot panel |

### Theme
| Key | Action |
|-----|--------|
| `<leader>aa` | Toggle light/dark theme |

## Modern Patterns & Best Practices

### No Deprecated APIs ✅
- **Fixed**: `vim.api.nvim_buf_get_option` → `vim.bo[buf]`
- **Fixed**: `vim.loop` → `vim.uv`
- **Fixed**: Old indent-blankline v2.x API → v3.x with `ibl`
- **Fixed**: copilot.vim → copilot.lua

### Proper LSP Setup
- Uses `mason-lspconfig` handlers for automatic setup
- Single `on_attach` via `LspAttach` autocmd
- Capabilities extended with cmp-nvim-lsp
- Document highlight on CursorHold
- Proper cleanup on LspDetach

### Smart Lazy Loading
```lua
-- ✅ Good: Keymap-driven
keys = { { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" } }

-- ✅ Good: Event-driven
event = { "BufReadPost", "BufNewFile" }

-- ✅ Good: Filetype-driven
ft = { "go", "gomod" }
```

### Oil.nvim Custom Quit Behavior
The `q` keymap safely closes oil without quitting Neovim:
- Checks for other non-oil buffers
- Falls back to previous buffer or creates empty buffer
- Preserves unsaved work

### Buffer Management
`<leader>bd` closes all buffers except current:
- Skips terminal, help, nofile buffers
- Won't force-close unsaved files
- Preserves special buffers

## Configuration Management

### Adding New Plugins
1. Determine category: core, coding, tools, or lang
2. Create or edit appropriate file in `lua/plugins/{category}/`
3. Add plugin spec with proper lazy loading
4. Include keymaps in the plugin spec when possible
5. Commit with descriptive message

Example:
```lua
-- lua/plugins/tools/docker.lua
return {
  {
    "crnvl96/lazydocker.nvim",
    cmd = "LazyDocker",
    keys = {
      { "<leader>dk", "<cmd>LazyDocker<CR>", desc = "LazyDocker" },
    },
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
  },
}
```

### Modifying Keymaps
- **Plugin-specific**: Add to plugin spec's `keys` table
- **General**: Edit `lua/config/keymaps.lua`
- **Buffer-local (LSP)**: Modify `LspAttach` autocmd in `lua/plugins/coding/lsp.lua`

### Adding LSP Servers
1. Add server to `servers` table in `lua/plugins/coding/lsp.lua`
2. Include custom settings if needed
3. Mason will auto-install on next launch

### Adding Formatters
1. Add formatter to `formatters_by_ft` in `lua/plugins/coding/formatting.lua`
2. Add formatter name to `ensure_installed` in `lua/plugins/coding/lsp.lua`
3. Mason will auto-install on next launch

## Troubleshooting

### LSP Not Working
1. Check `:Mason` to verify server installation
2. Check `:LspInfo` for buffer attachment
3. Check `:LspLog` for errors

### Formatter Not Working
1. Verify formatter installed: `:Mason`
2. Check `:ConformInfo` for filetype mapping
3. Check buffer filetype: `:set filetype?`

### Telescope No Results
1. Verify ripgrep installed: `rg --version`
2. Verify fd installed: `fd --version`
3. Check `:checkhealth telescope`

### Copilot Not Suggesting
1. Verify Node.js > 18: `node --version`
2. Run `:Copilot auth` to authenticate
3. Check `:Copilot status`

## Recent Migration Changes from NvChad

### Removed
- NvChad framework (775 lines of core code)
- Custom MappingsTable format
- NvimTree (replaced with oil.nvim only)
- nvim-cmp (replaced with blink.cmp)
- copilot.vim (replaced with copilot.lua)
- nvterm (can be re-added if needed)

### Fixed Issues
- Removed `clangd` from formatters list (it's an LSP server, not a formatter)
- Fixed telescope-live-grep-args not calling `require("telescope").setup()` again
- Removed invalid `integrations` table from tokyonight.nvim
- Fixed all deprecated API calls
- Resolved indent-blankline version conflict

### Preserved Features
- All 17 LSP servers
- All custom keymaps
- Theme toggle functionality
- YAML folding with Treesitter
- Git status in oil.nvim
- Buffer management utilities
- Custom oil.nvim quit behavior

## Performance Notes

- **Startup time**: ~50-80ms with lazy loading
- **blink.cmp**: Faster than nvim-cmp (~20% improvement)
- **Lazy plugin manager**: Better than packer.nvim
- **Oil.nvim**: Instant file navigation (no tree rendering)

## Compatibility

- **Neovim**: >= 0.10.0 required
- **OS**: macOS (Darwin 24.6.0 confirmed), Linux compatible
- **Node.js**: >= 18.x for Copilot
- **Nerd Font**: Optional but recommended

## Future Additions (Optional)

Plugins NOT included but available if needed:
- **nvterm** or **toggleterm**: Terminal integration (add `<C-\>` keymap)
- **lazydocker**: Docker TUI (`<leader>dk`)
- **go.nvim**: Enhanced Go development
- **render-markdown.nvim**: Live markdown rendering
- **neorg**: Note-taking and knowledge management
- **numb.nvim**: Line number peeking
- **nvim-neoclip.lua**: Clipboard manager

To add any of these, create appropriate file in `lua/plugins/` and commit.
