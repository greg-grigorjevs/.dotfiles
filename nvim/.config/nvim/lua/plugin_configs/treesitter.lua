return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = {
        -- blade needs to installed manually with :TSInstall blade
        'php',
        'php_only',
        'lua',
        'html',
        'css',
        'markdown',
        'markdown_inline',
        'javascript',
        'nix',
        'bash',
        'xml'
      },
      highlight = {
        enable = true,
        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = { "conf" },

        -- fixes indentation in react files
        additional_vim_regex_highlighting = { "jsx", "tsx", "js", "javascript", "javascriptreact", "typescriptreact",
          "svelte" },

      },
      indent = { enable = { 'php', 'blade', 'yaml', 'svelte', 'jsx', 'tsx', 'blade', 'markdown' } },
      --  autopairs = {enable = true},
      matchup = {
        enable = true,
      },
      rainbow = {
        enable = true,
        disable = { "php" },  -- list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = {
            ["]a"] = "@parameter.inner"
          },
          goto_previous_start = {
            ["[a"] = "@parameter.inner"
          }
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner"
          }
        },
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ik"] = "@block.inner",
            ["ak"] = "@block.outer",
            ["ac"] = "@comment.outer",
            ["ii"] = "@conditional.inner",
            ["ai"] = "@conditional.outer",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["as"] = "@statement.outer",
            ["aa"] = "@parameter.inner",
            ["aA"] = "@parameter.outer",

            -- You can optionally set descriptions to the mappings (used in the desc parameter of
            -- nvim_buf_set_keymap) which plugins like which-key display

            --[[ ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" }, ]]
            -- You can also use captures from other query groups like `locals.scm`
            --[[ ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" }, ]]

          },
          selection_modes = function(event, stuff)
            if event['query_string'] == '@parameter.inner' or event['query_string'] == '@parameter.outer' then
              return 'v'
            else
              return 'V'
            end
          end
        },
      },
    }
    local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

    -- Repeat movement with ; and ,
    -- ensure ; goes forward and , goes backward regardless of the last direction
    -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

    -- vim way: ; goes to the direction you were moving.
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    require('ts_context_commentstring').setup {
      enable = true,
      enable_autocmd = false,
    }
  end
}
