-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup {

  renderer = {
        add_trailing = false,
        group_empty = false,
        highlight_git = false,
        full_name = false,
        highlight_opened_files = "none",
        root_folder_modifier = ":~",
        indent_markers = {  -- closed
          enable = false,
          icons = { -- closed
            corner = "└",
            edge = "│",
            item = "│",
            none = " ",
          }, -- icons
        }, -- indent_markers
        icons = {
          webdev_colors = true,
          git_placement = "before",
          padding = " ",
          symlink_arrow = " ➛ ",
          show = {  -- closed
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          }, -- show 
          glyphs = {
            default = "",
            symlink = "",
            bookmark = "",
            folder = { -- closed
              arrow_closed = "",
              arrow_open = "",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
              default = "",
            }, --
            git = { -- closed 
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            } --
          } -- glyphs
        } -- icons
    },

  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  ignore_ft_on_setup = {
    "startify",
    "dashboard",
    "alpha",
  },

  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = true,    -- update current directory
--   update_to_buf_dir = {
--    enable = true,
--    auto_open = true,
--  },
  diagnostics = {       -- reflect bad things happen in the files
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = "left",
    -- auto_resize = true,
    mappings = {
      custom_only = false,
      list = {
        { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },    -- l to open a folder
        { key = "h", cb = tree_cb "close_node" },               -- h to close a folder
        { key = "v", cb = tree_cb "vsplit" },                   -- vertical split
      },
    },
    number = true,
    relativenumber = true,
  },
  -- quit_on_open = 0,
  -- git_hl = 1,
  -- disable_window_picker = 0,
  -- root_folder_modifier = ":t",
  -- show_icons = {
    -- git = 1,
    -- folders = 1,
    -- files = 1,
    -- folder_arrows = 1,
    -- tree_width = 30,
  -- },
}
