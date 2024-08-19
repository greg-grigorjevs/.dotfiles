return {
  'kyazdani42/nvim-tree.lua',
  lazy = false,
  -- enabled = false,
  config = function()
    require('nvim-tree').setup({
      filters = {
        dotfiles = false
      },
      view = {
        width = {}
      },
      actions = {
        change_dir = {
          global = true
        },
        open_file = {
          quit_on_open = true
        }
      },
      hijack_directories = {
        auto_open = false
      },

      sync_root_with_cwd = true
    })
  end

}
