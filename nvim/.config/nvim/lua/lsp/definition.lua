local M = {}

function M.jump_to_definition()
  local target_win = vim.api.nvim_get_current_win()
  local from = vim.fn.getpos('.')
  from[1] = vim.api.nvim_win_get_buf(target_win)
  local tagname = vim.fn.expand('<cword>')

  -- Use Neovim's location API so it builds request params with each client's
  -- position encoding. Its default definition handler is not registered in
  -- newer Neovim versions, so handle the resulting list directly.
  vim.lsp.buf.definition({
    on_list = function(options)
      -- Locations are sorted by file and position, so the class declaration
      -- comes before its constructor when both are returned.
      local item = options.items[1]
      if not item or not item.filename or not vim.api.nvim_win_is_valid(target_win) then
        return
      end

      local bufnr = item.bufnr or vim.fn.bufadd(item.filename)
      vim.bo[bufnr].buflisted = true

      vim.api.nvim_win_call(target_win, function()
        vim.cmd("normal! m'")
        vim.fn.settagstack(vim.fn.win_getid(), {
          items = { { tagname = tagname, from = { from[1], from[2], from[3], 0 } } },
        }, 't')
        vim.api.nvim_win_set_buf(target_win, bufnr)
        vim.api.nvim_win_set_cursor(target_win, { item.lnum, (item.col or 1) - 1 })
        vim.cmd('normal! zv')
      end)
    end,
  })
end

return M
