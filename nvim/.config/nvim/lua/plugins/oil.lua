-- Oil.nvim - Edit filesystem like a buffer
return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "refractalize/oil-git-status.nvim",
  },
  keys = {
    { "<leader>-", "<cmd>Oil<CR>", desc = "Open oil file explorer" },
  },
  opts = {
    -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
    default_file_explorer = false,
    -- Id is automatically added at the beginning, and name at the end
    columns = {
      "icon",
      "permissions",
      "size",
      "mtime",
    },
    -- Buffer-local options to use for oil buffers
    buf_options = {
      buflisted = false,
      bufhidden = "hide",
    },
    -- Window-local options to use for oil buffers
    win_options = {
      wrap = false,
      signcolumn = "yes:2",
      cursorcolumn = false,
      foldcolumn = "0",
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = "nvic",
    },
    -- Send deleted files to the trash instead of permanently deleting them
    delete_to_trash = false,
    -- Skip the confirmation popup for simple operations
    skip_confirm_for_simple_edits = false,
    -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
    prompt_save_on_select_new_entry = true,
    -- Oil will automatically delete hidden buffers after this delay
    cleanup_delay_ms = 2000,
    lsp_file_methods = {
      -- Enable or disable LSP file operations
      enabled = true,
      -- Time to wait for LSP file operations to complete before skipping
      timeout_ms = 1000,
      -- Set to true to autosave buffers that are updated with LSP willRenameFiles
      autosave_changes = false,
    },
    -- Constrain the cursor to the editable parts of the oil buffer
    constrain_cursor = "editable",
    -- Set to true to watch the filesystem for changes and reload oil
    watch_for_changes = false,
    -- Keymaps in oil buffer
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-s>"] = "actions.select_vsplit",
      ["<C-h>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<C-l>"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
      -- Custom close that doesn't quit Neovim
      ["q"] = function()
        -- Check if there are other non-oil buffers
        local buffers = vim.api.nvim_list_bufs()
        local non_oil_buffers = 0
        for _, buf in ipairs(buffers) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and vim.bo[buf].filetype ~= "oil" then
            non_oil_buffers = non_oil_buffers + 1
          end
        end

        if non_oil_buffers > 0 then
          -- Close oil buffer and return to previous buffer
          vim.cmd("bprevious")
        else
          -- If no other buffers, create a new empty buffer
          vim.cmd("enew")
        end
      end,
    },
    -- Set to false to disable all of the above keymaps
    use_default_keymaps = true,
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
      -- This function defines what is considered a "hidden" file
      is_hidden_file = function(name, bufnr)
        return vim.startswith(name, ".")
      end,
      -- This function defines what will never be shown, even when `show_hidden` is set
      is_always_hidden = function(name, bufnr)
        return false
      end,
      sort = {
        -- sort order can be "asc" or "desc"
        { "type", "asc" },
        { "name", "asc" },
      },
    },
    -- Configuration for the floating preview window
    preview = {
      -- Whether the preview window is automatically updated when the cursor is moved
      update_on_cursor_moved = true,
      -- Maximum file size in megabytes to preview
      max_file_size_mb = 100,
      -- Window-local options to use for preview window buffers
      win_options = {},
    },
  },
  config = function(_, opts)
    require("oil").setup(opts)
    -- Setup oil-git-status integration
    require("oil-git-status").setup({
      show_ignored = true,
      symbols = {
        index = {
          ["A"] = "󰈞", -- Added
          ["M"] = "󰏫", -- Modified
          ["D"] = "", -- Deleted
          ["R"] = "", -- Renamed
          ["C"] = "󰆏", -- Copied
          ["U"] = "", -- Unmerged
          ["?"] = "", -- Untracked
          [" "] = " ", -- Unchanged
        },
        working_tree = {
          ["A"] = "", -- Added
          ["M"] = "", -- Modified
          ["D"] = "", -- Deleted
          ["R"] = "", -- Renamed
          ["C"] = "󰆏", -- Copied
          ["U"] = "", -- Unmerged
          ["?"] = "", -- Untracked
          [" "] = " ", -- Unchanged
        },
      },
    })
  end,
}
