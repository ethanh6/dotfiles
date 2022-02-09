# Neovim configuration

# TODO
- [ ] update telescope keymaps
- [ ] configure nerd fonts

# File structure
```
├── README.md
├── init.lua
├── lua
│   └── user
│       ├── cmp.lua
│       ├── colorscheme.lua
│       ├── keymaps.lua
│       ├── lsp
│       │   ├── handlers.lua
│       │   ├── init.lua
│       │   ├── lsp-installer.lua
│       │   └── settings
│       │       ├── jsonls.lua
│       │       ├── pyright.lua
│       │       └── sumneko_lua.lua
│       ├── options.lua
│       ├── plugins.lua
│       ├── telescope.lua
│       └── treesitter.lua
├── plugin
│   └── packer_compiled.lua
└── treesitter.lua
```

# Setup symlink
~/.config/nvim -> ~/dotfiles/.config/nvim

```
$ ln -sf ~/dotfiles/.config/nvim/ ~/.config/nvim
```

# Plugins
| Functionality | Plugins |
| --- | --- |
| Plugin Manager | Packer.nvim |
| Fuzzy file search | telescope.nvim  | 
| LSP | nvim-lspconfig |
| Colorscheme | Tokyonight, Gruvbox |
| Status Line | lualine.nvim |
| Completion | nvim.cmp: the completin plugin managing completion recommendations from sources |
| Snippet | LuaSnip: the snippet engine |
| Nerd font | Hack |
| Startup Page | alpha-nvim | 

# Additional steps to fix errors:
- MarkdownPreview (plugin) 
```
$ cd ~/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim/app/
$ ./install.sh
```

# Lua: a lightweight scripting language
To run vimscript (as strings) inside lua
```
vim.cmd [[set isKeyword+=-]]
```


