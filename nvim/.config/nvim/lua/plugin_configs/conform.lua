return {
  "stevearc/conform.nvim",
  config = function()
    local conform = require('conform')
    conform.setup({
      formatters = {
        ['blade-formatter'] = {
          append_args = { '--sort-html-attributes=code-guide', '--sort-tailwindcss-classes' }
        }
      },
      formatters_by_ft = {
        blade = { 'blade-formatter' },
        nix = { 'nixpkgs_fmt' },
        html = { 'prettierd' },
        javascript = { 'prettierd' }
      },
      format_on_save = function()
        if vim.b.disable_autoformat == true then
          return
        end

        return { lsp_format = "fallback", timeout_ms = 3000 }
      end
    })

    -- Keymaps
    vim.keymap.set({ "n" }, "<leader>hd", function()
      vim.b.disable_autoformat = not vim.b.disable_autoformat
    end, { desc = "Toggle buffer autoformat", noremap = true })

    vim.keymap.set({ "n", "v" }, "<leader>hf", function()
      conform.format({
        lsp_fallback = true,
        async = true,
        timeout_ms = 3000
      })
    end, { desc = "Format file or range using conform" })
  end
}
