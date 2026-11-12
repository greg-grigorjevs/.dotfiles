local function navigate(direction, window_direction, tmux_command)
  return function()
    if not vim.env.HERDR_PANE_ID then
      vim.cmd(tmux_command)
      return
    end

    local window = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(window_direction)
    if vim.api.nvim_get_current_win() == window then
      local herdr = vim.env.HERDR_BIN_PATH
      if not herdr or vim.fn.executable(herdr) == 0 then
        herdr = 'herdr'
      end
      vim.system({ herdr, 'pane', 'focus', '--pane', vim.env.HERDR_PANE_ID, '--direction', direction })
    end
  end
end

return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
  },
  keys = {
    { "<C-Left>",  navigate('left', 'h', 'TmuxNavigateLeft') },
    { "<C-Down>",  navigate('down', 'j', 'TmuxNavigateDown') },
    { "<C-Up>",    navigate('up', 'k', 'TmuxNavigateUp') },
    { "<C-Right>", navigate('right', 'l', 'TmuxNavigateRight') },
  },
}
