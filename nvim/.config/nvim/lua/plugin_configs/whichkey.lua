return {
  'folke/which-key.nvim',
  config = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>e",   "<cmd>NvimTreeFindFileToggle<cr>",                                           desc = "File Tree" },

      { "<leader>f",   group = "Telescope" },
      { "<leader>fa",  "<cmd>Telescope find_files no_ignore=true hidden=true<cr>",                  desc = "All Files" },
      { "<leader>fb",  "<cmd>Telescope buffers sort_mru=true<cr>",                                  desc = "Buffers" },
      { "<leader>fc",  "<cmd>Telescope command_history<cr>",                                        desc = "Command History" },
      { "<leader>fd",  "<cmd>Telescope dap list_breakpoints<cr>",                                   desc = "Debugging Breakpoints" },
      { "<leader>fs",  "<cmd>Telescope live_grep<cr>",                                              desc = "Grep Search" },
      { "<leader>fS",  ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",  desc = "Grep Search with Args" },
      { "<leader>fh",  "<cmd>Telescope help_tags<cr>",                                              desc = "Help Tags" },
      { "<leader>fg",  "<cmd>Telescope git_status<cr>",                                             desc = "Git Status" },
      { "<leader>fy",  "<cmd>Telescope neoclip star<cr>",                                           desc = "Yank History" },
      { "<leader>fr",  "<cmd>Telescope resume<cr>",                                                 desc = "Last Search" },
      { "<leader>fo",  "<cmd>Telescope builtin<cr>",                                                desc = "List Telescope Options" },
      { "<leader>fu",  "<cmd>Telescope oldfiles only_cwd=true<cr>",                                 desc = "Recently Opened Files" },
      { "<leader>fp",  "<cmd>Telescope harpoon marks<cr>",                                          desc = "Har[p]oon" },
      { "<leader>fj",  "<cmd>Telescope jumplist show_line=false<cr>",                               desc = "[J]umplist" },
      { "<leader>f/",  "<cmd>Telescope current_buffer_fuzzy_find<cr>",                              desc = "Search Current File" },
      { "<leader>fl",  group = "LSP" },
      { "<leader>fls", "<cmd>Telescope lsp_document_symbols<cr>",                                   desc = "Document Symbols" },
      { "<leader>flS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",                          desc = "Workspace Symbols" },
      { "<leader>flr", "<cmd>Telescope lsp_references<cr>",                                         desc = "LSP References" },
      { "<leader>fld", "<cmd>Telescope diagnonstics<cr>",                                           desc = "LSP Diagnostics" },
      { "<leader>fm",  group = "Bookmarks" },
      { "<leader>fma", "<cmd>lua require('telescope').extensions.vim_bookmarks.all()<cr>",          desc = "Show [A]ll bookmarks" },
      { "<leader>fmc", "<cmd>lua require('telescope').extensions.vim_bookmarks.current_file()<cr>", desc = "Show bookmarks in the [c]urrent buffer" },

      { "<leader>g",   group = "Git" },
      { "<leader>gj",  "<cmd>lua require 'gitsigns'.next_hunk()<cr>",                               desc = "Next Hunk" },
      { "<leader>gk",  "<cmd>lua require 'gitsigns'.prev_hunk()<cr>",                               desc = "Prev Hunk" },
      { "<leader>gl",  "<cmd>Gitsigns toggle_current_line_blame<cr>",                               desc = "Blame Toggle" },
      { "<leader>gb",  "<cmd>Gitsigns blame_line<cr>",                                              desc = "Blame Line" },
      { "<leader>gp",  "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",                            desc = "Preview Hunk" },
      { "<leader>gr",  "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",                              desc = "Reset Hunk" },
      { "<leader>gR",  "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",                            desc = "Reset Buffer" },
      { "<leader>gs",  "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",                              desc = "Stage Hunk" },
      { "<leader>gs",  "<cmd>'<,'>Gitsigns stage_hunk<cr>",                                         mode = { 'v' },                                 desc = "Stage Hunk" },
      { "<leader>gu",  "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",                         desc = "Undo Stage Hunk" },
      { "<leader>gB",  "<cmd>Telescope git_branches<cr>",                                           desc = "Checkout branch" },
      { "<leader>gc",  "<cmd>Telescope git_commits<cr>",                                            desc = "Checkout commit" },
      { "<leader>gd",  group = "DiffView" },
      { "<leader>gdd", "<cmd>Gitsigns diffthis HEAD<cr>",                                           desc = "Diff" },
      { "<leader>gdo", "<cmd>DiffviewOpen<cr>",                                                     desc = "open" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>",                                                    desc = "close" },
      { "<leader>gdm", "<cmd>DiffviewOpen master",                                                  desc = "compare with master" },

      { "<leader>o",   group = "Obsidian" },
      { "<leader>on",  ":ObsidianNew ",                                                             desc = "[N]ew Obsidian Note" },
      { "<leader>op",  "<cmd>ObsidianOpen<CR>",                                                     desc = "O[p]en current note" },
      { "<leader>ot",  "<cmd>ObsidianToday<CR>",                                                    desc = "New Note for [T]oday" },


      { "<leader>t",   group = "Terminal/Test" },
      {
        "<leader>tg",
        "<cmd>FloatermNew --autoclose=2 --name=lazygit lazygit --use-config-file=\"$HOME/.dotfiles/lazygit/.config/lazygit/config.yml\"<cr>",
        desc = "lazygit"
      },
      { "<leader>tK", "<cmd>FloatermKill!<cr>",                                    desc = "Kill all terminals" },
      { "<leader>tt", "<cmd>FloatermShow lazygit<cr>",                             desc = "[T]oggle existing lazygit if exists" },
      { "<leader>tn", "<cmd>TestNearest<cr>",                                      desc = "Run Nearest [T]est" },
      { "<leader>tl", "<cmd>TestLast<cr>",                                         desc = "Run [L]ast test" },


      { '<leader>rr', "<cmd>ReloadBrowser<cr>",                                    desc = 'Reload Browser' },

      { "<leader>h",  group = "Harpoon/Format" },
      { "<leader>hp", "<cmd>Prettier<cr>",                                         desc = "Prettier" },
      { "<leader>ha", "<cmd>lua require 'harpoon.mark'.add_file()<cr>",            desc = "Add file to bookmarks" },
      { "<leader>ht", "<cmd>lua require 'harpoon.ui'.toggle_quick_menu()<cr>",     desc = "Toggle harpoon" },

      { "<leader>x",  group = "Trouble" },
      { "<leader>xx", "<cmd>TroubleToggle<cr>",                                    desc = "Toggle Trouble" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",              desc = "Workspace Diagnostics" },
      { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",               desc = "Document Diagnostics" },
      { "<leader>xr", "<cmd>TroubleToggle lsp_references<cr>",                     desc = "LSP References" },



      { '<leader>s',  group = 'Session' },
      { "<leader>sw", function() require('persistence').save() end,                desc = "Save" },
      { "<leader>sr", function() require('persistence').load({ last = true }) end, desc = "Restore" },



      { '<leader>y',  group = 'Yank' },
      { "<leader>yf", "<cmd>let @* = expand('%:t')<CR>",                           desc = "Current buffer's filename" },
      { "<leader>yp", "<cmd>let @* = expand('%')<CR>",                             desc = "Current buffer's relative path" },
      { "<leader>yP", "<cmd>let @* = expand('%:p')<CR>",                           desc = "Current buffer's full path" },

      { "<leader>w",  "<cmd>w<cr>",                                                desc = "Save File" },
      { "<leader>W",  "<cmd>wa<cr>",                                               desc = "Save All Files" },
      { "<leader>q",  "<cmd>q<cr>",                                                desc = "Close File" },
      { "<leader>Q",  "<cmd>qa!<cr>",                                              desc = "Quit Nvim" },

      { "<leader>%",  "<cmd>w<bar>so %<cr>",                                       desc = "Save and source current file" },

    })


    wk.add({
      { "<M-o>",  "<cmd>ObsidianQuickSwitch<CR>",                             desc = "[O]bsidian notes search" },
      { "<M-O>",  "<cmd>ObsidianSearch<CR>",                                  desc = "[O]bsidian notes grep search" },
      { "<C-\\>", "<cmd>FloatermToggle ft1 --width=0.9 --height=0.9<cr>",     desc = "Toggle Terminal" },
      { "<C-P>",  "<cmd>Telescope find_files<cr>",                            desc = "Find files" },
      { "<M-p>",  "<cmd>Telescope find_files no_ignore=true hidden=true<cr>", desc = "Find all files" },
    })



    wk.add({
      {
        '<C-_>',
        function()
          local line = vim.fn.line('.')
          -- vim.print(
          --   vim.treesitter.get_parser():language_for_range({vim.fn.line("."), 0, vim.fn.line("."), 0}):lang()
          -- )
          require('mini.comment').toggle_lines(line, line)
        end,
        desc = 'Comment current line'
      }
    })


    -- quickfix list mappings
    wk.add({
      { "<M-s>", "<cmd>tabnext<cr>", desc = "Next tab" },
      { "<M-b>", "<cmd>tabprev<cr>", desc = "Previous tab" }
    })

    -- visual mode mappings

    -- harpoon mappings
    wk.add({
      { "<M-1>", "<cmd>lua require'harpoon.ui'.nav_file(1)<cr>", desc = "Harpoon open file 1" },
      { "<M-2>", "<cmd>lua require'harpoon.ui'.nav_file(2)<cr>", desc = "Harpoon open file 2" },
      { "<M-3>", "<cmd>lua require'harpoon.ui'.nav_file(3)<cr>", desc = "Harpoon open file 3" },
      { "<M-4>", "<cmd>lua require'harpoon.ui'.nav_file(4)<cr>", desc = "Harpoon open file 4" },
      { "<M-5>", "<cmd>lua require'harpoon.ui'.nav_file(5)<cr>", desc = "Harpoon open file 5" },
      { "<M-6>", "<cmd>lua require'harpoon.ui'.nav_file(6)<cr>", desc = "Harpoon open file 6" },
      { "<M-7>", "<cmd>lua require'harpoon.ui'.nav_file(7)<cr>", desc = "Harpoon open file 7" },
      { "<M-8>", "<cmd>lua require'harpoon.ui'.nav_file(8)<cr>", desc = "Harpoon open file 8" },
      { "<M-9>", "<cmd>lua require'harpoon.ui'.nav_file(9)<cr>", desc = "Harpoon open file 9" },
    })

    --[[ which_key.register(harpoon_mappings) ]]
    --[[ which_key.register({
  ["<C-\\"] = {"<C-\\><C-n><cmd>FloatermToggle<cr>"}
}, {mode = "t"}); ]]
    -- couldn't make it work using which-key syntax
    vim.cmd [[
  tnoremap <C-\> <C-\><C-n>:FloatermToggle<cr>
  tnoremap ah <C-\><C-n>

  tnoremap   <silent>   <M-b>    <C-\><C-n>:FloatermPrev<CR>
  tnoremap   <silent>   <M-s>    <C-\><C-n>:FloatermNext<CR>
  tnoremap   <silent>   <M-x>    <C-\><C-n>:FloatermKill<CR>

  noremap G Gzz
  noremap <C-d> <C-d>zz
  noremap <C-u> <C-u>zz
]]
  end
}
