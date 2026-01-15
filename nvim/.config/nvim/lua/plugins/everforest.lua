-- Everforest theme for light mode
return {
  "neanias/everforest-nvim",
  priority = 1000,
  config = function()
    require("everforest").setup({
      background = "soft", -- hard, medium, soft
      transparent_background_level = 0,
    })
  end,
}
