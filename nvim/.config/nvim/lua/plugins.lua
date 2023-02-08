return require('packer').startup(function()

  use 'wbthomason/packer.nvim'

  -- Themes
  use { 'luisiacc/gruvbox-baby'}
  use { 'sainnhe/gruvbox-material' }
  --[[ use 'gruvbox-community/gruvbox' ]]
  use { 'ellisonleao/gruvbox.nvim' }
  use 'rebelot/kanagawa.nvim'
  use 'folke/tokyonight.nvim'

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'folke/which-key.nvim'
  use {
    'voldikss/vim-floaterm',
    config = function()
      vim.g.floaterm_width = 0.9
      vim.g.floaterm_height = 0.9
      vim.g.floaterm_opener = 'edit'
    end
  }

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
    branch = 'v1', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  use {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup {
        mapping = { "dj" }
      }
    end,
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
        default_delay = 3,
        extra_keymaps = true,
        extended_keymaps = true,
      } end
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
  use 'AckslD/nvim-neoclip.lua'

  -- use {
  --   'neoclide/coc.nvim',
  --   branch = 'release'
  -- }

  use 'mattn/emmet-vim'
  use 'tpope/vim-surround'

  use 'lewis6991/gitsigns.nvim' -- git integration

  use 'kyazdani42/nvim-web-devicons'
  use 'kyazdani42/nvim-tree.lua'
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
  use { 'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons' }


end)
