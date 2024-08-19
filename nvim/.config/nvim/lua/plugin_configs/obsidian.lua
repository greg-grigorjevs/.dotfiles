return {
  "epwalsh/obsidian.nvim",
  version = "*",   -- recommended, latest release instead of latest commit
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

  },
  config = function()
    require("obsidian").setup({
      workspaces = {
        -- {
        --   name = "personal",
        --   path = "~/vaults/personal",
        -- },
        {
          name = "work",
          -- path = "~/vaults/work",
          path = function()
            return '/Users/' .. os.getenv('USER') .. '/Library/Mobile Documents/iCloud~md~obsidian/Documents/vault'
          end
          -- strict = true
        },
      },
      -- creates new notes in the currently selected worspace which should be the default IMO
      -- but default is current dir
      new_notes_location = "notes_subdir",
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({ "open", url })   -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,
      open_app_foreground = true,

    })

    vim.o.conceallevel = 2
  end,
}
