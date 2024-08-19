return {
  'rmagatti/auto-session',
  config = function()
    require("auto-session").setup {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      auto_session_enable_last_session = true,
      auto_session_root_dir = vim.fn.stdpath('data') .. "/sessions/",
      -- These three doesn't seem to do anything
      auto_session_enabled = true,
      auto_save_enabled = true,
      auto_restore_enabled = true,
      ------------------------------------------
      -- auto_session_suppress_dirs = nil,
      auto_session_use_git_branch = nil,
      -- the configs below are lua only
      bypass_session_save_file_types = nil
    }
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end
}
