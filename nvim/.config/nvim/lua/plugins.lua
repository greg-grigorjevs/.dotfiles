-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = ""

-- Dadbod UI merges these nested icon tables into its defaults at load time.
vim.g.db_ui_icons = vim.g.db_ui_icons or {
  expanded = { db = '▾' },
  collapsed = { db = '▸' },
}

local plugins = {

  -- Colorschemes,
  'luisiacc/gruvbox-baby',
  { 'sainnhe/gruvbox-material', lazy = true },
  { 'ellisonleao/gruvbox.nvim', lazy = true },
  { 'rebelot/kanagawa.nvim', lazy = true },
  { 'folke/tokyonight.nvim', lazy = true },
  { 'marko-cerovac/material.nvim', lazy = true },
  { 'Mofiqul/vscode.nvim', lazy = true },
  { "olimorris/onedarkpro.nvim", lazy = true },

  { 'MaxMEllon/vim-jsx-pretty', ft = { 'javascriptreact', 'typescriptreact' } },
  { 'ThePrimeagen/harpoon', lazy = true },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup {}
    end
  },
  { 'andymass/vim-matchup', event = { 'BufReadPre', 'BufNewFile' } },
  { 'JoosepAlviste/nvim-ts-context-commentstring', lazy = true },
  {
    'mattn/emmet-vim',
    ft = { 'html', 'css', 'scss', 'less', 'javascriptreact', 'typescriptreact', 'svelte', 'blade', 'php' },
    init = function()
      vim.g.user_emmet_mode = 'a'
    end,
  },
  { 'tpope/vim-surround', event = { 'BufReadPre', 'BufNewFile' } },
  { 'kyazdani42/nvim-web-devicons', lazy = true },

  -- LSP
  { "williamboman/mason.nvim", cmd = { 'Mason', 'MasonInstall', 'MasonUpdate', 'MasonUninstall', 'MasonLog' } },
  { "williamboman/mason-lspconfig.nvim", lazy = true },
  { "jay-babu/mason-null-ls.nvim", lazy = true },
  { "nvimtools/none-ls.nvim", lazy = true },
  { 'neovim/nvim-lspconfig', event = { 'BufReadPre', 'BufNewFile' } },
  { 'hrsh7th/cmp-nvim-lsp', lazy = true },
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      'kristijanhusak/vim-dadbod-completion',
    },
    config = function()
      require('lsp.nvim-cmp')
    end,
  },

  { 'jwalton512/vim-blade', ft = { 'blade', 'php' } },

  { 'tpope/vim-repeat', event = { 'BufReadPre', 'BufNewFile' } },
  'MattesGroeger/vim-bookmarks',
  {
    'tom-anders/telescope-vim-bookmarks.nvim',
    lazy = true,
    init = function()
      vim.g.bookmark_save_per_working_dir = 0
      vim.g.bookmark_auto_save = 1
    end
  },

  {
    'tpope/vim-fugitive',
    cmd = { 'G', 'Git', 'Gdiffsplit', 'Gvdiffsplit', 'Gedit', 'Gread', 'Gwrite', 'Ggrep', 'Gclog', 'GBrowse' },
    dependencies = { 'tpope/vim-rhubarb', 'tommcdo/vim-fubitive' },
  },
  { 'nvim-treesitter/nvim-treesitter-context', event = { 'BufReadPost', 'BufNewFile' } },
  { "b0o/schemastore.nvim", lazy = true },
  {
    'fei6409/log-highlight.nvim',
    ft = 'log',
    config = function()
      require('log-highlight').setup {}
    end,
  },
  { 'kmonad/kmonad-vim', ft = 'kmonad' },
  { 'mbbill/undotree', cmd = { 'UndotreeToggle', 'UndotreeShow', 'UndotreeHide', 'UndotreeFocus' } },
  { 'stevearc/dressing.nvim', event = 'VeryLazy' },

  {
    "tpope/vim-dadbod",
    cmd = { 'DB', 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    dependencies = { 'kristijanhusak/vim-dadbod-ui', 'kristijanhusak/vim-dadbod-completion' },
    config = function()
      vim.g.db_ui_auto_execute_table_helpers = 1
    end
  },
  {
    "folke/todo-comments.nvim",
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('todo-comments').setup()
    end
  }
}

require('lazy').setup({
  spec = {
    plugins,
    { import = 'plugin_configs' }
  }
})
