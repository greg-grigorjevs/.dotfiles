return {
  'lewis6991/gitsigns.nvim', -- git integration
  opts = {
    signs = {
      add    = { text = '▎' },
      change = { text = '▎' },
    },
    on_attach = function()
      vim.wo.signcolumn = "yes:2"
    end
  }
}
