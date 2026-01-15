-- Add/change/delete surrounding delimiter pairs with ease
return {
  "kylechui/nvim-surround",
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-surround").setup({
      -- Configuration here, or leave empty to use defaults
      -- Examples:
      -- - Normal mode: ys{motion}{char} - Add surrounding
      -- - Normal mode: ds{char} - Delete surrounding
      -- - Normal mode: cs{target}{replacement} - Change surrounding
      -- - Visual mode: S{char} - Add surrounding
    })
  end,
}
