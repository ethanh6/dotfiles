-- Tokyo Night theme
return {
  "folke/tokyonight.nvim",
  priority = 1000,
  opts = {
    style = "night", -- storm, moon, night (darkest), day
    transparent = false,
    terminal_colors = true,
    styles = {
      comments = { italic = false },
      keywords = { italic = false },
      functions = {},
      variables = {},
    },
  },
}
