require('telescope').setup({
  defaults = {
    path_display = { 'truncate' },
    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      }
    },
    pickers = {
      --[[ jumplist = {show_line = false}, -- doesn't work ?! ]]
      lsp_dynamic_workspace_symbols = {show_line = false, fname_width = 100},
      lsp_document_symbols = {show_line = false, trim_text = true},
      lsp_references = {show_line = false, trim_text = true},
    },
    layout_config = {
      horizontal = { width = 0.99, height = 0.99, preview_width = 0.5 }
    },
    file_ignore_patterns = {
      "vendor/*",
      "%.lock",
      "__pycache__/*",
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
  }
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('harpoon')
