return {
  'kyazdani42/nvim-tree.lua',
  lazy = false,
  -- enabled = false,
  config = function()
    require('nvim-tree').setup({
      filters = {
        dotfiles = false,
        custom = { '.gitignore' }
      },
      view = {
        -- auto adjust width
        width = {}
      },
      actions = {
        change_dir = {
          global = true
        },
        expand_all = {
          exclude = { 'vendor', '.git', 'node_modules' }
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
