# Neovim configuration

# setup symlink
~/.config/nvim -> ~/dotfiles/.config/nvim

```
$ ln -sf ~/dotfiles/.config/nvim/ ~/.config/nvim
```

# File structure
```
~/.config/nvim/
|   init.lua
└───lua/user/                # the word "user" is arbitrary, for namespace purpose
│       options.lua          # options (e.g. set hlsearch) 
│       keymaps.lua          # keymaps (e.g. nnoremap <C-e> :Lex 30<CR>)
│       plugins.lua          # install plugins with packer.nvim
│       colorscheme.lua      # color schemes with error handling (in case the color scheme breaks)
│       cmp.lua              # auto completion config
└───plugin/
        packer-compiled.lua  # compiled lua file to speed things up, don't touch it

~/.local/share/
│     nvim/site/pack/packer/
│     └───start/            # plugins running when startup
│     └───opt/              # lazy loading plugins
└───fonts/                  # fonts are downloaded here

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

