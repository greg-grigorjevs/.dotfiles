require("nvim-treesitter.configs").setup {
	ensure_installed = "all",
	highlight = {
    enable = true,
     -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    --[[ disable = {"yaml"}, ]]

    -- fixes indentation in react files
    additional_vim_regex_highlighting = {"jsx", "tsx", "js", "javascript", "javascriptreact", "typescriptreact"},

  },
	indent = { enable = {'php', 'yaml', 'html'} },
--  autopairs = {enable = true},
  matchup = {
    enable = true,
  },
 rainbow = {
    enable = true,
    disable = { "php" }, -- list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
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
}

