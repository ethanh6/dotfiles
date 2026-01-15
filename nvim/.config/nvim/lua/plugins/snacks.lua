-- Snacks.nvim - Dashboard and utilities by folke
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- Project picker configuration
    picker = {
      sources = {
        projects = {
          dev = {
            "~/Documents/Notes",
            "~/projects",
            "~/myProject/",
            "~/myDev/",
            "~/myExercise/",
            "~/dotfiles",
            "~/.config/nvim",
          }, -- Directories to scan for projects
          patterns = { ".git", "package.json", "init.lua", "go.mod", "Makefile", "MODULE.bazel" },
          recent = true, -- Include recent file project roots
          max_depth = 3, -- How deep to scan dev directories
        },
      },
    },
    dashboard = {
      enabled = true,
      preset = {
        -- make it work, make it right, make it fast.
        -- ASCII art: AMC 3 Line, generated at https://patorjk.com/software/taag/
        header = [[
. . . .-. .-. . .   .-. .-. .-. . . .-.   .-. .-. .-. .-. 
| | | | | |(  |<    |(   |  |.. |-|  |    |-  |-| `-.  |  
`.'.' `-' ' ' ' `   ' ' `-' `-' ' `  '    '   ` ' `-'  '  
        ]],
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "b", desc = "Buffer", action = ":enew | startinsert" },
          -- { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          -- { icon = "󰛭 ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.dashboard.pick('projects')" },
          -- { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = "󱙺 ", key = "o", desc = "Obsidian Today", action = ":Obsidian today" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "k", desc = "Keymaps", action = ":lua Snacks.dashboard.pick('keymaps')" },
          { icon = " ", key = "h", desc = "Health Check", action = ":checkhealth" },
          { icon = " ", key = "q", desc = "¯\\_(ツ)_/¯", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 3 },
        { section = "startup" },
      },
    },
  },
}
