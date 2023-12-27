local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    blade = { 'blade-formatter' }
  }
})

vim.keymap.set({ "n", "v" }, "<leader>hf", function ()
  conform.format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500
  })
end, { desc = "Format file or range using conform" })
