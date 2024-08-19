return {
  'lukas-reineke/indent-blankline.nvim',
  commit = '9637670896b68805430e2f72cf5d16be5b97a22a',
  config = function()
    vim.g.indentLine_enabled = 1
    vim.g.indent_blankline_use_treesitter = true
    vim.g.indent_blankline_show_current_context = true
    vim.g.indent_blankline_show_first_indent_level = false
    require("indent_blankline").setup {
      -- space_char_blankline = " ",
      space_current_context = true,
      show_current_context_start = false
      -- show_current_context_start = true,
    }
  end
}
