-- Add indentation guides even on blank lines
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    indent = {
      char = "┊",
      tab_char = "┊",
    },
    scope = {
      char = "▎",
      show_start = false,
      show_end = false,
    },
  },
  config = function(_, opts)
    -- Define rainbow colors for indent guides
    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "IblIndent1", { fg = "#E06C75" })
      vim.api.nvim_set_hl(0, "IblIndent2", { fg = "#E5C07B" })
      vim.api.nvim_set_hl(0, "IblIndent3", { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "IblIndent4", { fg = "#D19A66" })
      vim.api.nvim_set_hl(0, "IblIndent5", { fg = "#98C379" })
      vim.api.nvim_set_hl(0, "IblIndent6", { fg = "#C678DD" })
      vim.api.nvim_set_hl(0, "IblIndent7", { fg = "#56B6C2" })
    end)

    -- Set the highlight groups for rainbow colors
    opts.indent.highlight = {
      "IblIndent1",
      "IblIndent2",
      "IblIndent3",
      "IblIndent4",
      "IblIndent5",
      "IblIndent6",
      "IblIndent7",
    }
    opts.scope.highlight = {
      "IblIndent1",
      "IblIndent2",
      "IblIndent3",
      "IblIndent4",
      "IblIndent5",
      "IblIndent6",
      "IblIndent7",
    }

    require("ibl").setup(opts)
  end,
}
