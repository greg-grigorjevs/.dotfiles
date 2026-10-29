return {
  'kyazdani42/nvim-tree.lua',
  cmd = { 'NvimTreeToggle', 'NvimTreeOpen', 'NvimTreeClose', 'NvimTreeFocus', 'NvimTreeFindFile', 'NvimTreeFindFileToggle' },
  -- enabled = false,
  config = function()
    -- Newer Neovim versions may not create netrw's legacy augroup.
    vim.api.nvim_create_augroup('FileExplorer', { clear = false })
    require('nvim-tree').setup({
      filters = {
        dotfiles = false,
        git_ignored = false,
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
