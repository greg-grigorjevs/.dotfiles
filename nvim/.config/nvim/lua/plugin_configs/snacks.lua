return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function(_, opts)
    require('snacks').setup(opts)
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
  end,
  opts = {
    -- image support is needed for SwiftUI/UIKit previews in xcodebuild.nvim
    image = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        files = {
          actions = {
            create_file = function(picker)
              require('custom.create_file').from_picker(picker:dir(), function()
                picker:close()
              end)
            end,
          },
          win = {
            input = {
              keys = {
                ['<M-n>'] = { 'create_file', mode = { 'i', 'n' }, desc = 'Create file or directory' },
              },
            },
          },
        },
      },
    },
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    -- bigfile = { enabled = true },
    -- notifier = { enabled = true },
    -- quickfile = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
  },
}
