return {
  'sindrets/diffview.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    local actions = require("diffview.actions")
    local function nmap(lhs, action, desc)
      return { "n", lhs, action, { desc = desc } }
    end

    require("diffview").setup({
      diff_binaries = false,    -- Show diffs for binaries
      enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
      git_cmd = { "git" },      -- The git executable followed by default args.
      use_icons = true,         -- Requires nvim-web-devicons
      icons = {                 -- Only applies when use_icons is true.
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
      },
      file_panel = {
        listing_style = "tree",            -- One of 'list' or 'tree'
        tree_options = {                   -- Only applies when listing_style is 'tree'
          flatten_dirs = true,             -- Flatten dirs that only contain one single dir
          folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
        },
        win_config = {                     -- See ':h diffview-config-win_config'
          position = "left",
          width = 35,
        },
      },
      file_history_panel = {
        log_options = { -- See ':h diffview-config-log_options'
          git = {
            single_file = {
              diff_merges = "combined",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          }
        },
        win_config = { -- See ':h diffview-config-win_config'
          position = "bottom",
          height = 16,
        },
      },
      commit_log_panel = {
        win_config = {}, -- See ':h diffview-config-win_config'
      },
      default_args = {   -- Default args prepended to the arg-list for the listed commands
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },
      hooks = {},                 -- See ':h diffview-config-hooks'
      keymaps = {
        disable_defaults = false, -- Disable the default keymaps
        view = {
          -- The `view` bindings are active in the diff buffers, only when the current
          -- tabpage is a Diffview.
          nmap("<tab>", actions.select_next_entry, "Open the diff for the next file"),
          nmap("<s-tab>", actions.select_prev_entry, "Open the diff for the previous file"),
          nmap("gf", actions.goto_file, "Open the file in a split in the previous tabpage"),
          nmap("<C-w><C-f>", actions.goto_file_split, "Open the file in a new split"),
          nmap("<C-w>gf", actions.goto_file_tab, "Open the file in a new tabpage"),
          nmap("<leader>e", actions.focus_files, "Bring focus to the file panel"),
          nmap("<leader>b", actions.toggle_files, "Toggle the file panel"),
        },
        file_panel = {
          nmap("j", actions.next_entry, "Move to the next file entry"),
          nmap("<down>", actions.next_entry, "Move to the next file entry"),
          nmap("k", actions.prev_entry, "Move to the previous file entry"),
          nmap("<up>", actions.prev_entry, "Move to the previous file entry"),
          nmap("<cr>", actions.select_entry, "Open the diff for the selected entry"),
          nmap("o", actions.select_entry, "Open the diff for the selected entry"),
          nmap("<2-LeftMouse>", actions.select_entry, "Open the diff for the selected entry"),
          nmap("-", actions.toggle_stage_entry, "Stage / unstage the selected entry"),
          nmap("S", actions.stage_all, "Stage all entries"),
          nmap("U", actions.unstage_all, "Unstage all entries"),
          nmap("X", actions.restore_entry, "Restore entry to the state on the left side"),
          nmap("R", actions.refresh_files, "Refresh stats and entries in the file list"),
          nmap("L", actions.open_commit_log, "Open the commit log panel"),
          nmap("<c-b>", actions.scroll_view(-0.25), "Scroll the view up"),
          nmap("<c-f>", actions.scroll_view(0.25), "Scroll the view down"),
          nmap("<tab>", actions.select_next_entry, "Open the diff for the next file"),
          nmap("<s-tab>", actions.select_prev_entry, "Open the diff for the previous file"),
          nmap("gf", actions.goto_file, "Open the file in a split in the previous tabpage"),
          nmap("<C-w><C-f>", actions.goto_file_split, "Open the file in a new split"),
          nmap("<C-w>gf", actions.goto_file_tab, "Open the file in a new tabpage"),
          nmap("i", actions.listing_style, "Toggle between list and tree views"),
          nmap("f", actions.toggle_flatten_dirs, "Flatten empty subdirectories in the tree"),
          nmap("<leader>e", actions.focus_files, "Bring focus to the file panel"),
          nmap("<leader>b", actions.toggle_files, "Toggle the file panel"),
        },
        file_history_panel = {
          nmap("g!", actions.options, "Open the option panel"),
          nmap("<C-A-d>", actions.open_in_diffview, "Open the selected entry in a diffview"),
          nmap("y", actions.copy_hash, "Copy the selected commit hash"),
          nmap("L", actions.open_commit_log, "Open the commit log panel"),
          nmap("zR", actions.open_all_folds, "Expand all folds"),
          nmap("zM", actions.close_all_folds, "Collapse all folds"),
          nmap("j", actions.next_entry, "Move to the next file entry"),
          nmap("<down>", actions.next_entry, "Move to the next file entry"),
          nmap("k", actions.prev_entry, "Move to the previous file entry"),
          nmap("<up>", actions.prev_entry, "Move to the previous file entry"),
          nmap("<cr>", actions.select_entry, "Open the diff for the selected entry"),
          nmap("o", actions.select_entry, "Open the diff for the selected entry"),
          nmap("<2-LeftMouse>", actions.select_entry, "Open the diff for the selected entry"),
          nmap("<c-b>", actions.scroll_view(-0.25), "Scroll the view up"),
          nmap("<c-f>", actions.scroll_view(0.25), "Scroll the view down"),
          nmap("<tab>", actions.select_next_entry, "Open the diff for the next file"),
          nmap("<s-tab>", actions.select_prev_entry, "Open the diff for the previous file"),
          nmap("gf", actions.goto_file, "Open the file in a split in the previous tabpage"),
          nmap("<C-w><C-f>", actions.goto_file_split, "Open the file in a new split"),
          nmap("<C-w>gf", actions.goto_file_tab, "Open the file in a new tabpage"),
          nmap("<leader>e", actions.focus_files, "Bring focus to the file panel"),
          nmap("<leader>b", actions.toggle_files, "Toggle the file panel"),
        },
        option_panel = {
          nmap("<tab>", actions.select_entry, "Change the current option"),
          nmap("q", actions.close, "Close the panel"),
        },
      },
    })
  end
}
