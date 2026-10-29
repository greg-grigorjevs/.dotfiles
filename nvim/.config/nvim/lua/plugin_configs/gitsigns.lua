return {
  'lewis6991/gitsigns.nvim', -- git integration
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = 'Gitsigns',
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
