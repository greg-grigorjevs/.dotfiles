return {
  'voldikss/vim-floaterm',
  cmd = { 'FloatermNew', 'FloatermToggle', 'FloatermShow', 'FloatermHide', 'FloatermKill', 'FloatermNext', 'FloatermPrev', 'FloatermSend' },
  config = function()
    vim.g.floaterm_width = 0.99
    vim.g.floaterm_height = 0.99
    vim.g.floaterm_opener = 'edit'
    local palette = {
      '#282a36', '#ff5c57', '#5af78e', '#f3f99d',
      '#57c7ff', '#ff6ac1', '#9aedfe', '#f1f1f0',
      '#686868', '#ff5c57', '#5af78e', '#f3f99d',
      '#57c7ff', '#ff6ac1', '#9aedfe', '#eff0eb',
    }
    local namespace = vim.api.nvim_create_namespace('LazygitSnazzy')
    for _, group in ipairs({ 'Normal', 'NormalNC', 'NormalFloat', 'Floaterm', 'FloatermNC' }) do
      vim.api.nvim_set_hl(namespace, group, { fg = '#eff0eb', bg = '#282a36' })
    end
    vim.api.nvim_create_autocmd({ 'TermOpen', 'BufWinEnter' }, {
      group = vim.api.nvim_create_augroup('LazygitSnazzy', { clear = true }),
      callback = function(event)
        if vim.b[event.buf].floaterm_name ~= 'lazygit' then
          return
        end
        if event.event == 'TermOpen' then
          for index, color in ipairs(palette) do
            vim.b[event.buf]['terminal_color_' .. (index - 1)] = color
          end
        end
        for _, window in ipairs(vim.fn.win_findbuf(event.buf)) do
          vim.api.nvim_win_set_hl_ns(window, namespace)
        end
      end,
    })
    -- vim.g.floaterm_keymap_prev = '<M-b>'
    -- vim.g.floaterm_keymap_next = '<M-s>'
  end
}
