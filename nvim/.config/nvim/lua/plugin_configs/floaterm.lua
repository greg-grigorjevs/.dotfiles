return {
  'voldikss/vim-floaterm',
  config = function()
    vim.g.floaterm_width = 0.99
    vim.g.floaterm_height = 0.99
    vim.g.floaterm_opener = 'edit'
    -- vim.g.floaterm_keymap_prev = '<M-b>'
    -- vim.g.floaterm_keymap_next = '<M-s>'
  end
}
