return {
  'lewis6991/gitsigns.nvim', -- git integration
  config = function()
    require('gitsigns').setup {
      on_attach = function()
        vim.wo.signcolumn = "yes:2"
      end
    }
  end
}
