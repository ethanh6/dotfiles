# neovim configuration

## the sym link
~/.config/nvim -> ~/dotfiles/.config/nvim

``` $ ln -sf ~/dotfiles/.config/nvim/ ~/.config/nvim ```

## file structure
- ~/.local/share/nvim/plugged/    # add plugins here
- ~/.config/nvim/
	- init.vim          # root config and plugins
	- maps.vim          # keymaps
	- after/            # post-init scripts
	- plug.vim          # vimplug config (don't use it now, move content into init.vim) 
		- plugin/         # plugin config
	- colors/           # color theme


## Ingredients
1. vim-plug
2. telescope.nvim  --> more customizability can be done
3. nvim-lspconfig  --> how to use it? 
4. lualine.nvim    --> status line

## todo
1. set up lua in each plugin 
2. biult-in language server or Coc? 

