-- Statusline
return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "lewis6991/gitsigns.nvim",
  },
  event = "VeryLazy",
  opts = function()
    -- Noice integration for macro recording and command display
    local noice_ok, noice = pcall(require, "noice")

    return {
      options = {
        theme = "catppuccin",
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "starter" },
        },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = " ",
              warn = " ",
              hint = " ",
              info = " ",
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        },
        lualine_x = {
          -- Noice macro recording
          {
            function()
              return noice.api.status.mode.get()
            end,
            cond = function()
              return noice_ok and noice.api.status.mode.has()
            end,
            color = { fg = "#ff9e64" },
          },
          -- Noice search count
          {
            function()
              return noice.api.status.search.get()
            end,
            cond = function()
              return noice_ok and noice.api.status.search.has()
            end,
            color = { fg = "#ff9e64" },
          },
          -- LSP clients
          {
            function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if #clients == 0 then
                return ""
              end
              local names = {}
              for _, client in ipairs(clients) do
                table.insert(names, client.name)
              end
              return " " .. table.concat(names, ", ")
            end,
          },
        },
        lualine_y = {
          { "encoding", show_bomb = true },
          { "fileformat", symbols = { unix = "", dos = "", mac = "" } },
          "filetype",
        },
        lualine_z = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "lazy", "oil", "quickfix", "man" },
    }
  end,
}
