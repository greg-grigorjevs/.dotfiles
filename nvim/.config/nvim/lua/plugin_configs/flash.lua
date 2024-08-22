return {
  'folke/flash.nvim',
  config = function()
    local ok, flash = pcall(require, 'flash')
    if not ok then
      return
    end

    flash.setup({
      modes = {
        char = {
          enabled = true,
          multi_line = false,
          autohide = true,
          jump_labels = true,
          highlight = { backdrop = false },
          label = { current = false }
        }
      }
    })

    flash.toggle(false)

    vim.keymap.set({ "n", "x", "o" }, "s", function()
      flash.jump({
        search = {
          forward = true,
          wrap = false,
          multi_window = false,
          mode = function(str)
            return "\\<" .. str
          end
        }
      })
    end, { desc = "Flash Forward Search" })
    vim.keymap.set({ "n", "x", "o" }, "S", function()
      flash.jump({
        search = {
          forward = false,
          wrap = false,
          multi_window = false,
          mode = function(str)
            return "\\<" .. str
          end
        }
      })
    end, { desc = "Flash" })
    --[[ vim.keymap.set({ "n", "o", "x" }, "S", function() flash.treesitter() end, { desc = "Flash Treesitter" }) ]]
    vim.keymap.set("o", "r", function() flash.remote() end, { desc = "Remote Flash" })
    -- vim.keymap.set({ "o", "x" }, "R", function() flash.treesitter_search() end, { desc = "Flash Treesitter Search" })
    vim.keymap.set({ "n", "o", "x" }, "R", function() flash.treesitter() end, { desc = "Flash Treesitter Search" })
    vim.keymap.set({ "c" }, "<c-s>", function() flash.toggle() end, { desc = "Toggle Flash Search" })

    vim.keymap.set({ 'n' }, "gs", function()
        require('flash').jump({
          action = function(match, state)
            vim.api.nvim_win_call(match.win, function()
              vim.api.nvim_win_set_cursor(match.win, match.pos)
              -- vim.lsp.buf.go
              require('trouble').toggle('lsp_definitions')
            end)
          end,
          search = {
            mode = function(str)
              return "\\<" .. str
            end
          }
        })
      end,
      { desc = "Jump to definition" })

    vim.keymap.set({ 'n', 'x', 'o' }, "L", function()
      require("flash").jump({
        search = { mode = "search", max_length = 0 },
        label = { after = { 0, 0 } },
        pattern = "^"
      })
    end, { desc = 'Go to line' })


    vim.keymap.set({ 'n' }, "gl", function()
      require('flash').jump({
        action = function(match, state)
          vim.api.nvim_win_call(match.win, function()
            vim.api.nvim_win_set_cursor(match.win, match.pos)
            require('Comment.api').toggle.linewise.current()
          end)
          state:restore()
        end,
        search = { mode = "search", max_length = 0 },
        label = { after = { 0, 0 } },
        pattern = "^"
      })
    end, { desc = 'Comment on jump' })

    vim.keymap.set({ 'n' }, 'g.', function()
      require('flash').jump({ continue = true })
    end, { desc = 'Repeat Jump' })
  end
}
