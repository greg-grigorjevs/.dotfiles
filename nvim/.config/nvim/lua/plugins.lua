return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- Colorschemes
  use { 'luisiacc/gruvbox-baby' }
  use { 'sainnhe/gruvbox-material' }
  --[[ use 'gruvbox-community/gruvbox' ]]
  use { 'ellisonleao/gruvbox.nvim' }
  use 'rebelot/kanagawa.nvim'
  use 'folke/tokyonight.nvim'
  use 'marko-cerovac/material.nvim'
  use 'Mofiqul/vscode.nvim'

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'folke/which-key.nvim'
  use {
    'voldikss/vim-floaterm',
    config = function()
      vim.g.floaterm_width = 0.99
      vim.g.floaterm_height = 0.99
      vim.g.floaterm_opener = 'edit'
    end
  }

  use "olimorris/onedarkpro.nvim"

  use {
    'MaxMEllon/vim-jsx-pretty',
  }

  use {
    'norcalli/nvim-colorizer.lua',
    disable = true,
    config = function()
      require 'colorizer'.setup({ "*" }, { mode = "foreground" })
    end
  }

  use 'ThePrimeagen/harpoon'

  use { 'windwp/nvim-autopairs', config = function()
    require('nvim-autopairs').setup {}
  end
  }


  -- use 'scrooloose/nerdtree'
  use 'andymass/vim-matchup' -- significatly expands % functionality
  --[[ use 'p00f/nvim-ts-rainbow' ]]

  use {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup {
        mapping = { "ah", "tn" } -- engram and colemak
      }
    end,
  }
  use {
    'phaazon/mind.nvim',
    branch = 'v2.2',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require 'mind'.setup()
    end
  }

  use {
    'rmagatti/auto-session',
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      }
    end
  }
  -- smooth scrolling
  --[[ use { ]]
  --[[   'karb94/neoscroll.nvim', ]]
  --[[   config = function() ]]
  --[[     require("neoscroll").setup { ]]
  --[[       easing_function = "quadratic", ]]
  --[[     } ]]
  --[[   end, ]]
  --[[ } ]]
  use {
    'declancm/cinnamon.nvim',
    config = function()
      require('cinnamon').setup {
        default_delay = 0.1,
        extra_keymaps = true,
        extended_keymaps = true,
      }
    end,
    disable = true
  }

  use 'JoosepAlviste/nvim-ts-context-commentstring' -- support for jsx commenting

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {
        -- add support for jsx comments
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
      local ft = require('Comment.ft')
      ft.set('blade', { '{{-- %s --}}', '{{-- %s --}}' })
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' }
    }
  }

  use {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require "telescope".load_extension("frecency")
    end,
    requires = { "kkharji/sqlite.lua" },
    disable = true
  }

  use 'AckslD/nvim-neoclip.lua'

  -- use {
  --   'neoclide/coc.nvim',
  --   branch = 'release'
  -- }

  use 'mattn/emmet-vim'
  use 'tpope/vim-surround'

  use 'lewis6991/gitsigns.nvim' -- git integration

  use 'kyazdani42/nvim-web-devicons'
  use { 'kyazdani42/nvim-tree.lua', lock = true } -- locked because of the deprecation of open_on_setup which I use. If needed to unlock then go to https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
  use {
    'lukas-reineke/indent-blankline.nvim',
    commit = '9637670896b68805430e2f72cf5d16be5b97a22a',
    config = function()
      vim.g.indentLine_enabled = 1
      vim.g.indent_blankline_use_treesitter = true
      vim.g.indent_blankline_show_current_context = true
      vim.g.indent_blankline_show_first_indent_level = false
      require("indent_blankline").setup {
        -- space_char_blankline = " ",
        space_current_context = true,
        show_current_context_start = false
        -- show_current_context_start = true,
      }
    end
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- LSP
  use {
    "williamboman/nvim-lsp-installer",
    config = function()
      require('nvim-lsp-installer').setup()
    end
  }
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'

  -- For luasnip users.
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  use 'folke/trouble.nvim'
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
  use 'jwalton512/vim-blade'
  use { 'akinsho/bufferline.nvim', disable = true, tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons' } -- disabled for barbar.nvim
  use { 'romgrk/barbar.nvim', disable = true }
  -- som
  -- Markdown
  -- preview
  use { "ellisonleao/glow.nvim", config = function() require("glow").setup({ width_ratio = 0.7, height_ratio = 0.7 }) end }

  use 'tpope/vim-repeat' -- dot-repeat for some plugins
  use 'MattesGroeger/vim-bookmarks'
  use { 'tom-anders/telescope-vim-bookmarks.nvim',
    config = function()
      vim.g.bookmark_save_per_working_dir = 0
      vim.g.bookmark_auto_save = 1
    end
  }

  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'    -- support GBrowse for github
  use 'tommcdo/vim-fubitive' -- support GBrowse for bitbucket
  use 'nvim-treesitter/nvim-treesitter-context'
  use "b0o/schemastore.nvim"

  -- Debugging
  use { 'mfussenegger/nvim-dap', requires = { 'nvim-neotest/nvim-nio' } }
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'nvim-telescope/telescope-dap.nvim'
  use 'mortepau/codicons.nvim'

  --[[ use 'sheerun/vim-polyglot' ]]
  use 'folke/flash.nvim'

  use 'stevearc/oil.nvim'

  use('jose-elias-alvarez/null-ls.nvim')
  use('MunifTanjim/prettier.nvim')

  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  })

  use "stevearc/conform.nvim"

  use {
    'laytan/tailwind-sorter.nvim',
    requires = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
    config = function() require('tailwind-sorter').setup() end,
    run = 'cd formatter && npm i && npm run build',
  }

  use {
    'fei6409/log-highlight.nvim',
    config = function()
      require('log-highlight').setup {}
    end,
  }

  use { 'windwp/nvim-ts-autotag' }

  use({
    "epwalsh/obsidian.nvim",
    tag = "*", -- recommended, use latest release instead of latest commit
    requires = {
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
          vim.fn.jobstart({ "open", url }) -- Mac OS
          -- vim.fn.jobstart({"xdg-open", url})  -- linux
        end,
        open_app_foreground = true,

      })

      vim.o.conceallevel = 2
    end,
  })

  use 'nvim-treesitter/playground'
  use('kmonad/kmonad-vim')

  -- didn't work for some reason. could't run neotest.run.run
  use {
    "nvim-neotest/neotest",
    disable = true,
    requires = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "olimorris/neotest-phpunit",
      config = function()
        require("neotest").setup({
          adapters = {
            require("neotest-phpunit")
          }
        })
      end
    }
  }

  -- use this instead of neotest
  use {
    "vim-test/vim-test",
    config = function()
      vim.cmd([[
        let test#php#phpunit#executable = 'php artisan test'
        " let test#strategy = 'floaterm'
        let test#strategy = 'neovim_sticky'
        let test#neovim#term_position = "vert"
        let test#neovim_sticky#reopen_window = 1
      ]])
    end
  }

  use {
    "kdheepak/lazygit.nvim",
    config = function()
      vim.g.lazygit_floating_window_scaling_factor = 1 -- scaling factor for floating window
    end
  }
  -- packer
  use {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  }

  use 'mbbill/undotree'

  -- database
  use {
    "tpope/vim-dadbod",
    requires = { 'kristijanhusak/vim-dadbod-ui', 'kristijanhusak/vim-dadbod-completion'}
  }

  use '~/.dotfiles/nvim/.config/nvim/custom/flash-def'
  use {
    'folke/neodev.nvim',
  }
end)
