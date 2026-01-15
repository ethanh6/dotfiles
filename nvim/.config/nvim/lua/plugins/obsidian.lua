-- Obsidian.nvim - Note taking with Obsidian vault integration
return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- use latest release, remove to use latest commit
  ft = "markdown",
  cmd = { "Obsidian" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "saghen/blink.cmp",
  },
  keys = {
    { "<leader>on", "<cmd>Obsidian new<CR>", desc = "[O]bsidian [N]ew note" },
    { "<leader>oo", "<cmd>Obsidian quick_switch<CR>", desc = "[O]bsidian [O]pen note" },
    { "<leader>ot", "<cmd>Obsidian today<CR>", desc = "[O]bsidian [T]oday" },
    { "<leader>oy", "<cmd>Obsidian yesterday<CR>", desc = "[O]bsidian [Y]esterday" },
    { "<leader>os", "<cmd>Obsidian search<CR>", desc = "[O]bsidian [S]earch" },
    { "<leader>ob", "<cmd>Obsidian backlinks<CR>", desc = "[O]bsidian [B]acklinks" },
    { "<leader>ol", "<cmd>Obsidian links<CR>", desc = "[O]bsidian [L]inks" },
    { "<leader>ow", "<cmd>Obsidian workspace<CR>", desc = "[O]bsidian [W]orkspace" },
    { "<leader>or", "<cmd>Obsidian rename<CR>", desc = "[O]bsidian [R]ename" },
  },
  opts = {
    -- Update this to your vault path(s)
    workspaces = {
      {
        name = "notes",
        path = "~/Documents/Notes/obsidian-vault",
      },
      -- Add more workspaces as needed:
      -- { name = "work", path = "~/work/notes" },
    },

    -- Daily notes configuration
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
      template = nil, -- Set to a template file path if desired
    },

    -- Use telescope for picking
    picker = {
      name = "telescope.nvim",
    },

    -- Completion settings (works with blink.cmp)
    completion = {
      nvim_cmp = false, -- Using blink.cmp instead
      min_chars = 2,
    },

    -- How to generate note IDs
    note_id_func = function(title)
      -- Use title as filename if provided, otherwise timestamp
      if title ~= nil then
        return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        return tostring(os.time())
      end
    end,

    -- Wiki links style
    wiki_link_func = "use_alias_only",

    -- Disable legacy commands (ObsidianNew -> Obsidian new)
    legacy_commands = false,

    -- UI settings
    ui = {
      enable = true,
    },

    -- Checkbox configuration
    checkbox = {
      states = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
      },
      order = { " ", "x", ">", "~" },
    },
  },
}
