return {
  "stevearc/conform.nvim",
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        blade = { { 'prettierd', 'prettier' } }
      },
      format_on_save = {
        -- I recommend these options. See :help conform.format for details.
        lsp_format = "fallback",
        timeout_ms = 500,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>hf", function()
      conform.format({
        lsp_fallback = true,
        async = true,
        timeout_ms = 3000
      })
    end, { desc = "Format file or range using conform" })
  end
}
