return {
  'jose-elias-alvarez/null-ls.nvim',
  enabled = false,
  config = function()
    local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
    local event = "BufWritePre" -- or "BufWritePost"
    local async = event == "BufWritePost"

    require('null_ls').setup({
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.keymap.set("n", "<Leader>hf", function()
            vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
          end, { buffer = bufnr, desc = "[lsp] format" })
        end

        if client.supports_method("textDocument/rangeFormatting") then
          vim.keymap.set("x", "<Leader>hf", function()
            vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
          end, { buffer = bufnr, desc = "[lsp] format" })
        end
      end,
    })
  end
}
