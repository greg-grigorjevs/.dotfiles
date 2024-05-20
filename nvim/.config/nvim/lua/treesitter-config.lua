require("nvim-treesitter.configs").setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "conf" },

    -- fixes indentation in react files
    additional_vim_regex_highlighting = { "jsx", "tsx", "js", "javascript", "javascriptreact", "typescriptreact", "svelte" },

  },
  indent = { enable = { 'php', 'yaml', 'html', 'svelte', 'jsx', 'tsx', 'blade', 'markdown' } },
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
        ["il"] = "@loop.inner"

        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display

        --[[ ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" }, ]]
        -- You can also use captures from other query groups like `locals.scm`
        --[[ ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" }, ]]
      },
      selection_modes = 'V'
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      --[[ selection_modes = { ]]
      --[[   ['@parameter.outer'] = 'v', -- charwise ]]
      --[[   ['@function.outer'] = 'V', -- linewise ]]
      --[[   ['@class.outer'] = '<c-v>', -- blockwise ]]
      --[[ }, ]]
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      --[[ include_surrounding_whitespace = true, ]]
    },
  },
  autotag = {
    enable = true,
    enable_rename = true,
    enable_close = true,
    enable_close_on_slash = true,
    filetypes = {
      'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
      'xml',
      'php', 'blade',
      'markdown',
      'astro', 'glimmer', 'handlebars', 'hbs'
    }
  },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.blade = {
  install_info = {
    url = "https://github.com/EmranMR/tree-sitter-blade",
    files = { "src/parser.c" },
    branch = "main",
  },
  filetype = "blade"
}

require('ts_context_commentstring').setup {
  enable = true,
  enable_autocmd = false,
}
