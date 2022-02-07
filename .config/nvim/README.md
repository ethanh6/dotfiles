# Neovim configuration

# setup symlink
~/.config/nvim -> ~/dotfiles/.config/nvim

```
$ ln -sf ~/dotfiles/.config/nvim/ ~/.config/nvim
```

# file structure
- ~/.config/nvim/
	- init.lua
  - lua/
    - user/                # the word "user" is arbitrary, for namespace purpose
      - options.lua        # options (e.g. set hlsearch) 
      - keymaps.lua        # keymaps (e.g. nnoremap <C-e> :Lex 30<CR>)
      - plugins.lua        # install plugins with packer.nvim
      - colorscheme.lua    # color schemes with error handling (in case the color scheme breaks)
      - cmp.lua            # auto completion config
  - plugin/
    - packer-compiled.lua  # compiled lua file to speed things up, don't touch it

- ~/.local/share/
  - nvim/site/pack/packer/
    - start/                 # plugins running when startup
    - opt/                   # lazy loading plugins
  - fonts/                   # fonts are downloaded here

# Plugins
- Plugin Manger: Packer.nvim
- telescope.nvim  
- nvim-lspconfig  

## Colorscheme
- Tokyonight
- gruvbox
- lualine.nvim    --> status line

## Completion & Snippet
- nvim.cmp        --> the completin plugin (manage completion recommendations from different source)
- LuaSnip         --> the engine

## Nerd font (developer font, for the cool icons)
- Hack

# Lua: a lightweight scripting language
To run vimscript (as strings) inside lua
```
vim.cmd [[set isKeyword+=-]]
```

