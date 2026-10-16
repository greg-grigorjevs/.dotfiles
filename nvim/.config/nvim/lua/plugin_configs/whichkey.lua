return {
  'folke/which-key.nvim',
  opts = {
    plugins = {
      presets = {
        g = false,
        text_objects = false
      }
    }
  },
  config = function()
    local Snacks = require("snacks")
    local wk = require("which-key")

    local function copy_opencode_location(is_visual)
      local path = vim.fn.expand("%:p:.")
      if path == "" or vim.bo.buftype ~= "" then
        vim.notify("No file path for current buffer", vim.log.levels.WARN)
        return
      end

      local start_line = vim.fn.line(".")
      local end_line = start_line
      if is_visual then
        start_line = vim.fn.line("v")
        end_line = vim.fn.line(".")
        if start_line > end_line then
          start_line, end_line = end_line, start_line
        end
      end

      local location = ("@%s#%d"):format(path, start_line)
      if end_line > start_line then
        location = location .. "-" .. end_line
      end

      vim.fn.setreg("+", location)
      vim.notify("Copied " .. location)
    end

    wk.add({
      { "<leader>e",   "<cmd>NvimTreeFindFileToggle<cr>",                                           desc = "File Tree" },

      { "<leader>f",   group = "Find" },
      { "<leader>fa",  function() require('fff').find_files() end,                                  desc = "Find Files" },
      { "<leader>fb",  function() Snacks.picker.buffers({ sort_lastused = true }) end,              desc = "Buffers" },
      { "<leader>fc",  function() Snacks.picker.command_history() end,                              desc = "Command History" },
      { "<leader>fd",  function() require('dap').list_breakpoints(true) end,                        desc = "Debugging Breakpoints" },
      { "<leader>fs",  function() require('fff').live_grep() end,                                   desc = "Grep Search" },
      { "<leader>fS",  function() require('fff').live_grep({ grep = { modes = { 'regex' } } }) end, desc = "Regex Grep" },
      { "<leader>fh",  function() Snacks.picker.help() end,                                         desc = "Help Tags" },
      { "<leader>fg",  function() Snacks.picker.git_status() end,                                   desc = "Git Status" },
      { "<leader>fy",  function() require('custom.fff').yank_history() end,                         desc = "Yank History" },
      { "<leader>fr",  function() require('fff').resume() end,                                      desc = "Last Search" },
      { "<leader>fo",  function() Snacks.picker.pickers() end,                                      desc = "List Available Pickers" },
      { "<leader>fu",  function() Snacks.picker.recent({ filter = { cwd = true } }) end,            desc = "Recently Opened Files" },
      { "<leader>fp",  function() require('harpoon.ui').toggle_quick_menu() end,                    desc = "Har[p]oon" },
      { "<leader>fj",  function() Snacks.picker.jumps() end,                                        desc = "[J]umplist" },
      { "<leader>f/",  function() Snacks.picker.lines() end,                                        desc = "Search Current File" },
      { "<leader>fl",  group = "LSP" },
      { "<leader>fls", function() Snacks.picker.lsp_symbols() end,                                  desc = "Document Symbols" },
      { "<leader>flS", function() Snacks.picker.lsp_workspace_symbols() end,                        desc = "Workspace Symbols" },
      { "<leader>flr", function() Snacks.picker.lsp_references() end,                               desc = "LSP References" },
      { "<leader>fld", function() Snacks.picker.diagnostics() end,                                  desc = "LSP Diagnostics" },
      { "<leader>fm",  group = "Bookmarks" },
      { "<leader>fma", "<cmd>BookmarkShowAll<cr>",                                                  desc = "Show [A]ll bookmarks" },
      { "<leader>fmc", "<cmd>BookmarkNext<cr>",                                                     desc = "Next [c]urrent-file bookmark" },

      { "<leader>g",   group = "Git" },
      { "<leader>gj",  "<cmd>lua require 'gitsigns'.next_hunk()<cr>",                               desc = "Next Hunk" },
      { "<leader>gk",  "<cmd>lua require 'gitsigns'.prev_hunk()<cr>",                               desc = "Prev Hunk" },
      { "<leader>gl",  "<cmd>Gitsigns toggle_current_line_blame<cr>",                               desc = "Blame Toggle" },
      { "<leader>gb",  "<cmd>Gitsigns blame_line<cr>",                                              desc = "Blame Line" },
      { "<leader>gp",  "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",                            desc = "Preview Hunk" },
      { "<leader>gr",  "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",                              desc = "Reset Hunk" },
      { "<leader>gR",  "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",                            desc = "Reset Buffer" },
      { "<leader>gs",  "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",                              desc = "Stage Hunk" },
      { "<leader>gS",  "<cmd>lua require 'gitsigns'.stage_buffer()<cr>",                            desc = "Stage Buffer" },
      { "<leader>gs",  "<cmd>'<,'>Gitsigns stage_hunk<cr>",                                         mode = { "x", "v" },                  desc = "Stage Hunk Visual" },
      { "<leader>gs",  "<cmd>Gitsigns stage_hunk<cr>",                                              mode = "n",                           desc = "Stage Hunk" },
      { "<leader>gu",  "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",                         desc = "Undo Stage Hunk" },
      { "<leader>gB",  function() Snacks.picker.git_branches() end,                                 desc = "Checkout branch" },
      { "<leader>gc",  ':G commit -m "',                                                            desc = "Checkout commit" },
      { "<leader>gd",  group = "DiffView" },
      { "<leader>gdd", "<cmd>Gitsigns diffthis HEAD<cr>",                                           desc = "Diff" },
      { "<leader>gdo", "<cmd>DiffviewOpen<cr>",                                                     desc = "open" },
      { "<leader>gdc", "<cmd>DiffviewClose<cr>",                                                    desc = "close" },
      { "<leader>gdm", "<cmd>DiffviewOpen master<cr>",                                              desc = "compare with master" },

      { "<leader>t",   group = "Terminal/Test" },
      {
        "<leader>tg",
        "<cmd>FloatermNew --autoclose=always --name=lazygit lazygit --use-config-file=\"$HOME/.dotfiles/lazygit/.config/lazygit/config.yml\"<cr>",
        desc = "lazygit"
      },
      { "<leader>ty", "<cmd>FloatermNew yazi<cr>",                             desc = "yazi file explorer" },
      { "<leader>tK", "<cmd>FloatermKill!<cr>",                                desc = "Kill all terminals" },
      { "<leader>tt", "<cmd>FloatermShow lazygit<cr>",                         desc = "[T]oggle existing lazygit if exists" },
      { "<leader>tn", "<cmd>TestNearest<cr>",                                  desc = "Run Nearest [T]est" },
      { "<leader>tl", "<cmd>TestLast<cr>",                                     desc = "Run [L]ast test" },
      { "<leader>tf", "<cmd>TestFile<cr>",                                     desc = "Run [F]ile test" },


      { '<leader>rr', "<cmd>ReloadBrowser<cr>",                                desc = 'Reload Browser' },

      { "<leader>h",  group = "Harpoon/Format" },
      { "<leader>hp", "<cmd>Prettier<cr>",                                     desc = "Prettier" },
      { "<leader>ha", "<cmd>lua require 'harpoon.mark'.add_file()<cr>",        desc = "Add file to bookmarks" },
      { "<leader>ht", "<cmd>lua require 'harpoon.ui'.toggle_quick_menu()<cr>", desc = "Toggle harpoon" },

      { "<leader>x",  group = "Trouble" },
      { "<leader>xx", "<cmd>Trouble<cr>",                                      desc = "Toggle Trouble" },
      { "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>",                desc = "Workspace Diagnostics" },
      { "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",                 desc = "Document Diagnostics" },
      -- { "<leader>xr", "<cmd>Trouble lsp_references win.position=left<cr>",     desc = "LSP References" },
      { "<leader>xr", "<cmd>Trouble lsp_references<cr>",                       desc = "LSP References" },

      { "<leader>X",  group = "Xcode" },
      { "<leader>XX", "<cmd>XcodebuildPicker<cr>",                 desc = "Show All Actions" },
      { "<leader>Xf", "<cmd>XcodebuildProjectManager<cr>",         desc = "Project Manager" },
      { "<leader>Xb", "<cmd>XcodebuildBuild<cr>",                  desc = "Build" },
      { "<leader>XB", "<cmd>XcodebuildBuildForTesting<cr>",        desc = "Build For Testing" },
      { "<leader>Xr", "<cmd>XcodebuildBuildRun<cr>",               desc = "Build & Run" },
      { "<leader>Xt", "<cmd>XcodebuildTest<cr>",                   desc = "Run Tests" },
      { "<leader>Xt", "<cmd>XcodebuildTestSelected<cr>",           mode = { "v" }, desc = "Run Selected Tests" },
      { "<leader>XT", "<cmd>XcodebuildTestClass<cr>",              desc = "Run Current Test Class" },
      { "<leader>X.", "<cmd>XcodebuildTestRepeat<cr>",             desc = "Repeat Last Test Run" },
      { "<leader>Xl", "<cmd>XcodebuildToggleLogs<cr>",             desc = "Toggle Logs" },
      { "<leader>Xc", "<cmd>XcodebuildToggleCodeCoverage<cr>",     desc = "Toggle Code Coverage" },
      { "<leader>XC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", desc = "Code Coverage Report" },
      { "<leader>Xe", "<cmd>XcodebuildTestExplorerToggle<cr>",     desc = "Toggle Test Explorer" },
      { "<leader>Xs", "<cmd>XcodebuildFailingSnapshots<cr>",       desc = "Failing Snapshots" },
      { "<leader>Xp", "<cmd>XcodebuildPreviewGenerateAndShow<cr>", desc = "Generate Preview" },
      { "<leader>X<cr>", "<cmd>XcodebuildPreviewToggle<cr>",       desc = "Toggle Preview" },
      { "<leader>Xd", "<cmd>XcodebuildSelectDevice<cr>",           desc = "Select Device" },
      { "<leader>Xq", "<cmd>Telescope quickfix<cr>",               desc = "Quickfix List" },
      { "<leader>Xx", "<cmd>XcodebuildQuickfixLine<cr>",           desc = "Quickfix Line" },
      { "<leader>Xa", "<cmd>XcodebuildCodeActions<cr>",            desc = "Code Actions" },



      { '<leader>s',  group = 'Session' },
      { "<leader>sw", function() require('persistence').save() end,            desc = "Save" },
      { "<leader>sr", function() require('persistence').load() end,            desc = "Restore" },



      { '<leader>y',  group = 'Yank' },
      { "<leader>yf", "<cmd>let @* = expand('%:t')<CR>",                       desc = "Current buffer's filename" },
      { "<leader>yp", "<cmd>let @* = expand('%')<CR>",                         desc = "Current buffer's relative path" },
      { "<leader>yP", "<cmd>let @* = expand('%:p')<CR>",                       desc = "Current buffer's full path" },
      {
        "<leader>yc",
        function() copy_opencode_location(false) end,
        mode = "n",
        desc = "Copy OpenCode location",
      },
      {
        "<leader>yc",
        function() copy_opencode_location(true) end,
        mode = "x",
        desc = "Copy OpenCode location",
      },

      { "<leader>w", "<cmd>w<cr>",          desc = "Save File" },
      { "<leader>W", "<cmd>wa<cr>",         desc = "Save All Files" },
      { "<leader>q", "<cmd>q<cr>",          desc = "Close File" },
      { "<leader>Q", "<cmd>qa!<cr>",        desc = "Quit Nvim" },

      { "<leader>%", "<cmd>w<bar>so %<cr>", desc = "Save and source current file" },

    })


    wk.add({
      { "<C-\\>", "<cmd>FloatermToggle ft1 --width=0.9 --height=0.9<cr>",                desc = "Toggle Terminal" },
      { "<C-P>",  function() require('fff').find_files() end,                            desc = "Find files" },
      { "<M-p>",  function() Snacks.picker.files({ hidden = true, ignored = true }) end, desc = "Find all files" },
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
      { "<M-b>", "<cmd>tabprev<cr>", desc = "Previous tab" },
      { "<M-h>", "<cmd>cnext<cr>",   desc = "Quickfix next" },
      { "<M-t>", "<cmd>cprev<cr>",   desc = "Quickfix prev" }
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

  " Free Alt+B for word-left in terminal apps (Kitty maps Alt+Left to Esc-b).
  tnoremap   <silent>   <M-S-b>  <C-\><C-n>:FloatermPrev<CR>
  tnoremap   <silent>   <M-s>    <C-\><C-n>:FloatermNext<CR>
  tnoremap   <silent>   <M-x>    <C-\><C-n>:FloatermKill<CR>

  noremap G Gzz
  noremap <C-d> <C-d>zz
  noremap <C-u> <C-u>zz
]]
  end
}
