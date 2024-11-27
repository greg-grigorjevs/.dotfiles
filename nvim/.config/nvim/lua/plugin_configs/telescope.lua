local harpoon = require('harpoon.mark')
local actions = require('telescope.actions')
local state = require('telescope.actions.state')
local utils = require('telescope.actions.utils')

return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-live-grep-args.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim',    build = 'make' },
    },
    config = function()
      local lga_actions = require("telescope-live-grep-args.actions")

      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = require('telescope.actions').close,
              ["<C-h>"] = function(prompt_bufnr)
                -- Get the currently selected entries (multiple files)
                local selections = {}
                utils.map_selections(prompt_bufnr, function(selection)
                  table.insert(selections, selection.value)
                end)

                if #selections == 0 then
                  harpoon.add_file(state.get_selected_entry().value)
                  actions.select_default(prompt_bufnr)
                else
                  -- Iterate over all selected entries and add them to Harpoon
                  for _, path in ipairs(selections) do
                    harpoon.add_file(path)
                  end
                  actions.close(prompt_bufnr)
                  require('harpoon.ui').toggle_quick_menu()
                end
              end
            }
          },
          path_display = { 'truncate' },
          pickers = {
            --[[ jumplist = {show_line = false}, -- doesn't work ?! ]]
            lsp_dynamic_workspace_symbols = { show_line = false, fname_width = 100 },
            lsp_document_symbols = { show_line = false, trim_text = true },
            lsp_references = { show_line = false, trim_text = true },
          },
          layout_config = {
            horizontal = { width = 0.99, height = 0.99, preview_width = 0.5 }
          },
          cache_picker = { num_pickers = 5 },
          file_ignore_patterns = {
            "vendor/*",
            "%.lock",
            "__pycache__/*",
            "goaccess/daily/*",
            "%.sqlite3",
            "%.ipynb",
            "node_modules/*",
            "%.jpg",
            "%.jpeg",
            "%.png",
            "%.svg",
            "%.otf",
            "%.ttf",
            ".git/",
            "%.webp",
            ".dart_tool/",
            ".github/",
            ".gradle/",
            ".idea/",
            ".settings/",
            ".vscode/",
            "__pycache__/",
            "build/",
            "env/",
            "gradle/",
            "node_modules/",
            "target/",
            "%.pdb",
            "%.dll",
            "%.class",
            "%.exe",
            "%.cache",
            "%.ico",
            "%.pdf",
            "%.dylib",
            "%.jar",
            "%.docx",
            "%.met",
            "smalljre_*/*",
            ".vale/",
            "public/js/app.js"
          },
        },
        extensions = {
          file_browser = {
            -- depth = false,
            hidden = true,
            git_status = false,
            -- hidden = {file_browser = true, folder_browser = true}
          },
          fzf = {
            minimum_grep_characters = 2,
            fuzzy                   = true,         -- false will only do exact matching
            override_generic_sorter = true,         -- override the generic sorter
            override_file_sorter    = true,         -- override the file sorter
            case_mode               = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = {         -- extend mappings
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              },
            },
            -- ... also accepts theme settings, for example:
            -- theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            -- layout_config = { mirror=true }, -- mirror preview pane
          }
          --[[ frecency = {
        default_workspace='CWD',
        show_unindexed=false,
      } ]]
        },
      })

      require('telescope').load_extension('fzf')
      require('telescope').load_extension('harpoon')
      require('telescope').load_extension('vim_bookmarks')
      require('telescope').load_extension('live_grep_args')
      require('telescope').load_extension('file_browser')
    end
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    enabled = false,
    config = function()
      require "telescope".load_extension("frecency")
    end,
    dependencies = { "kkharji/sqlite.lua" },
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
}
