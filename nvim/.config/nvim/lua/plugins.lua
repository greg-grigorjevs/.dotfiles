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

local plugins = {

  -- Colorschemes,
  'luisiacc/gruvbox-baby',
  'sainnhe/gruvbox-material',
  'ellisonleao/gruvbox.nvim',
  'rebelot/kanagawa.nvim',
  'folke/tokyonight.nvim',
  'marko-cerovac/material.nvim',
  'Mofiqul/vscode.nvim',
  "olimorris/onedarkpro.nvim",

  'MaxMEllon/vim-jsx-pretty',
  'ThePrimeagen/harpoon',

  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup {}
    end
  },
  'andymass/vim-matchup',                        -- significatly expands % functionality
  'JoosepAlviste/nvim-ts-context-commentstring', -- support for jsx commenting
  'mattn/emmet-vim',
  'tpope/vim-surround',
  'kyazdani42/nvim-web-devicons',

  -- LSP
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  'neovim/nvim-lspconfig',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp-signature-help',

  'jwalton512/vim-blade',

  'tpope/vim-repeat', -- dot-repeat for some plugins
  'MattesGroeger/vim-bookmarks',
  {
    'tom-anders/telescope-vim-bookmarks.nvim',
    config = function()
      vim.g.bookmark_save_per_working_dir = 0
      vim.g.bookmark_auto_save = 1
    end
  },

  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',    -- support GBrowse for github
  'tommcdo/vim-fubitive', -- support GBrowse for bitbucket
  'nvim-treesitter/nvim-treesitter-context',
  "b0o/schemastore.nvim",
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    'fei6409/log-highlight.nvim',
    config = function()
      require('log-highlight').setup {}
    end,
  },
  'windwp/nvim-ts-autotag',
  'nvim-treesitter/playground',
  'kmonad/kmonad-vim',
  'mbbill/undotree',

  {
    "tpope/vim-dadbod",
    dependencies = { 'kristijanhusak/vim-dadbod-ui', 'kristijanhusak/vim-dadbod-completion' },
    config = function()
      vim.g.db_ui_auto_execute_table_helpers = 1
    end
  },
  {
    "folke/todo-comments.nvim",
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
