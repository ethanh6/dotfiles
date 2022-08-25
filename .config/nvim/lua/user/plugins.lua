local fn = vim.fn

-- Automatically install packer if not installed
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so it don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  vim.notify("packer did't work")
  return
end

-- manually setup initialization. pass a table to packer.init() 
packer.init {
  -- Have packer use a popup window by overwriting open_fn
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install plugins here
return packer.startup(function(use)

  -- plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim"    -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim"  -- Useful lua functions used ny lots of plugins

  -- colorschemes
  use 'morhetz/gruvbox'
  use 'folke/tokyonight.nvim'

  -- cmp plugins (completion) 
  use "hrsh7th/nvim-cmp"         -- The completion plugin
  use "hrsh7th/cmp-buffer"       -- buffer completions
  use "hrsh7th/cmp-path"         -- path completions
  use "hrsh7th/cmp-cmdline"      -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"

  -- snippets
  use "L3MON4D3/LuaSnip"             --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- start page
  use {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.startify'.config)
    end
  }

  -- LSP
  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/nvim-lsp-installer" -- simple to use language server installer
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
  
  -- for python linting: pylink or pep8 

  -- Telescope
  use { "nvim-telescope/telescope.nvim",
        tag='0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'nvim-telescope/telescope-media-files.nvim'  -- preview image in telescope
  use "BurntSushi/ripgrep"  -- regex file search, suggested dependency by official
  use "sharkdp/fd"  -- `find` alternative, suggested dependency by official


  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }

  -- nice rainbow bracket
  use "p00f/nvim-ts-rainbow"

  -- indent level visual guide
  use { "lukas-reineke/indent-blankline.nvim",
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
    show_end_of_line = false,
  }

  -- MarkdownPreview
  -- cd app && ./install.sh
  use {'iamcco/markdown-preview.nvim'}

  -- Comment
  use "numToStr/Comment.nvim"
  use 'JoosepAlviste/nvim-ts-context-commentstring'   -- ts stands for treesitter

  -- Autopair
  use "windwp/nvim-autopairs"

  -- Gitsign
  use "lewis6991/gitsigns.nvim"

  -- nvim tree (file explorer)
  use 'kyazdani42/nvim-web-devicons'
  use 'kyazdani42/nvim-tree.lua'

  -- bufferline
  use "akinsho/bufferline.nvim"
  use "moll/vim-bbye"

  -- solidity
  use "tomlion/vim-solidity"

  -- toggle termimal
  use "akinsho/toggleterm.nvim"

  -- latex
  use "lervag/vimtex"


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)


