-- Fuzzy Finder (files, lsp, etc)
return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      -- If encountering errors, see telescope-fzf-native README for installation instructions
      "nvim-telescope/telescope-fzf-native.nvim",

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = "make",

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },

    -- Live grep with args extension for advanced searching
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      version = "^1.0.0",
    },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local lga_actions = require("telescope-live-grep-args.actions")

    telescope.setup({
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
        -- Bordered layout
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = true, -- Show files ignored by .gitignore
        },
        live_grep = {
          additional_args = { "--no-ignore" },
        },
        buffers = {
          mappings = {
            i = {
              ["<C-k>"] = actions.delete_buffer,
              ["<C-j>"] = actions.nop,
            },
            n = {
              ["<C-k>"] = actions.delete_buffer,
              ["<C-j>"] = actions.nop,
            },
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          -- define mappings, e.g.
          mappings = {
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              -- freeze the current list and start a fuzzy search in the frozen list
              ["<C-space>"] = lga_actions.to_fuzzy_refine,
            },
          },
        },
      },
    })

    -- Enable Telescope extensions if they are installed
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
    pcall(telescope.load_extension, "live_grep_args")

    -- See `:help telescope.builtin`
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
    vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
    vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "[F]ind [S]elect Telescope" })
    vim.keymap.set(
      "n",
      "<leader>fw",
      telescope.extensions.live_grep_args.live_grep_args,
      { desc = "[F]ind by [W]ord (with args)" }
    )
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
    vim.keymap.set("n", "<leader>fd", function()
      builtin.diagnostics({ bufnr = 0 })
    end, { desc = "[F]ind [D]iagnostics (buffer)" })
    vim.keymap.set("n", "<leader>fD", builtin.diagnostics, { desc = "[F]ind [D]iagnostics (all files)" })
    vim.keymap.set("n", "<leader>fl", builtin.resume, { desc = "[F]ind [L]ast (resume)" })
    vim.keymap.set("n", "<leader>fr", builtin.registers, { desc = "[F]ind [R]egisters" })
    vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "[F]ind [O]ld (recent) files" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind existing [B]uffers" })
    vim.keymap.set("n", "<leader>fz", builtin.current_buffer_fuzzy_find, { desc = "[F]ind fu[Z]zy in buffer" })

    -- Additional custom telescope pickers
    vim.keymap.set("n", "<leader>fcmd", builtin.commands, { desc = "[F]ind [C]o[m]man[d]s" })
    vim.keymap.set("n", "<leader>fch", builtin.command_history, { desc = "[F]ind [C]ommand [H]istory" })
    vim.keymap.set("n", "<leader>fsh", builtin.search_history, { desc = "[F]ind [S]earch [H]istory" })
    vim.keymap.set("n", "<leader>fgc", builtin.git_commits, { desc = "[F]ind [G]it [C]ommits" })
    vim.keymap.set("n", "<leader>fgt", builtin.git_status, { desc = "[F]ind [G]it S[t]atus" })
    vim.keymap.set("n", "<leader>fth", function()
      builtin.colorscheme({ enable_preview = true })
    end, { desc = "[F]ind [T]heme (colorscheme)" })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set("n", "<leader>/", function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Fuzzily search in current buffer" })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set("n", "<leader>f/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end, { desc = "[F]ind [/] in Open Files" })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set("n", "<leader>fn", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "[F]ind [N]eovim files" })
  end,
}
