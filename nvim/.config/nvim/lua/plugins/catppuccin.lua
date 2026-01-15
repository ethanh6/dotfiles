-- Catppuccin theme (default)
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    flavour = "mocha", -- latte, frappe, macchiato, mocha (darkest)
    transparent_background = false,
    integrations = {
      telescope = { enabled = true },
      which_key = true,
      treesitter = true,
      mason = true,
      gitsigns = true,
      markdown = true,
      blink_cmp = true,
      noice = true,
      notify = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    -- Set catppuccin as default colorscheme
    vim.cmd.colorscheme("catppuccin")
  end,
}
