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
    config = function()
      require 'colorizer'.setup({ "*" }, { mode = "foreground" })
    end
  }

  use 'ThePrimeagen/harpoon'

  --[[
  use {'windwp/nvim-autopairs', config = function()
    require('nvim-autopairs').setup{}
  end
  }

  --]]

  use 'jiangmiao/auto-pairs'
  -- use 'scrooloose/nerdtree'
  use 'andymass/vim-matchup' -- significatly expands % functionality
  use 'p00f/nvim-ts-rainbow'

  -- plugin for motions
  use {
    'phaazon/hop.nvim',
    disable = true, -- disabled for lightspeed
    branch = 'v1', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup {
        keys = 'etovxqpdygfblzhckisuran',
        jump_on_sole_occurence = true
      }
    end
  }

  use {
    'ggandor/lightspeed.nvim',
    disable = true,
    config = function()
      require('lightspeed').opts.ignore_case = true
    end
  }

  use 'ggandor/leap.nvim'

  use {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup {
        mapping = { "dj" }
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
    end
  }

  use 'JoosepAlviste/nvim-ts-context-commentstring' -- support for jsx commenting

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {
        -- add support for jsx comments
        pre_hook = function(ctx)
          local U = require 'Comment.utils'

          local location = nil
          if ctx.ctype == U.ctype.block then
            location = require('ts_context_commentstring.utils').get_cursor_location()
          elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require('ts_context_commentstring.utils').get_visual_start_location()
          end

          return require('ts_context_commentstring.internal').calculate_commentstring {
            key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
            location = location,
          }
        end,
      }
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require "telescope".load_extension("frecency")
    end,
    requires = { "kkharji/sqlite.lua" }
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
  use 'romgrk/barbar.nvim'
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
  use 'nvim-treesitter/nvim-treesitter-context'
  use "b0o/schemastore.nvim"

end)
