# Neovim configuration

# TODO
- [ ] update telescope keymaps
- [ ] configure nerd fonts
- [ ] add link to plugins repo

# File structure
```
├── README.md
├── init.lua
├── init.vim.old
├── lua
│   └── user
│       ├── autopairs.lua
│       ├── bufferline.lua
│       ├── cmp.lua
│       ├── colorscheme.lua
│       ├── comment.lua
│       ├── gitsigns.lua
│       ├── keymaps.lua
│       ├── lsp
│       │   ├── handlers.lua
│       │   ├── init.lua
│       │   ├── lsp-installer.lua
│       │   ├── null-ls.lua
│       │   └── settings
│       │       ├── jsonls.lua
│       │       ├── pyright.lua
│       │       ├── solang.lua
│       │       └── sumneko_lua.lua
│       ├── nvim-tree.lua
│       ├── options.lua
│       ├── plugins.lua
│       ├── telescope.lua
│       ├── toggleterm.lua
│       └── treesitter.lua
└── plugin
    └── packer_compiled.lua
```

## Setup symlink
~/.config/nvim -> ~/dotfiles/.config/nvim

```
$ ln -sf ~/dotfiles/.config/nvim/ ~/.config/nvim
```

## Neovim Plugins
| Functionality | Plugins |
| --- | --- |
| Plugin Manager | packer.nvim |
| Fuzzy file search | telescope.nvim  | 
| LSP | nvim-lspconfig |
| Colorscheme | tokyonight, gruvbox |
| Status Line | lualine.nvim |
| Completion | nvim.cmp: the completin plugin managing completion recommendations from sources |
| Snippet | LuaSnip: the snippet engine |
| Nerd font | Hack |
| Startup Page | alpha-nvim | 
| Autopair bracket | autopairs | 
| Comment | comment.nvim | 
| Git integration | gitsigns.nvim | 
| MarkdownPreview | markdown-preview.nvim | 
| Toggle terminal | [Toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim/issues?q=is%3Aopen) |
| Linting | [Null-ls](https://github.com/jose-elias-alvarez/null-ls.nvim) |

## Keymaps
| Key | Functionality | Plugin |
| --- | --- | --- | 
| `<M-e>` | FastWrap | windwp/nvim-autopairs |
| `<C-\>` | toggle floating terminal | toggler term |

## Additional steps to fix errors:
- MarkdownPreview (plugin) 
```
$ cd ~/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim/app/
$ ./install.sh
```

## Lua: a lightweight scripting language
To run vimscript (as strings) inside lua
```
vim.cmd [[set isKeyword+=-]]
```


