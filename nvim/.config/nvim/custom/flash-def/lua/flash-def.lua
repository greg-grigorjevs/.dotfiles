vim.api.nvim_create_user_command('Reload', function()
  package.loaded['flash-def'] = nil

  require('flash-def')
end, {})

vim.keymap.set('n', '<leader>a', '<cmd>Reload<cr>')

--[[ require('flash').jump({
  action = function(match, state)
    vim.api.nvim_win_call(match.win, function()
      vim.api.nvim_win_set_cursor(match.win, match.pos)
      -- vim.lsp.buf.go
      require('trouble').toggle('lsp_definitions')
    end)
  end,
  search = {
    mode = function(str)
      return "\\<" .. str
    end
  }
}) ]]

require('flash').jump({
  action = function(match, state)
    vim.api.nvim_win_call(match.win, function()
      vim.api.nvim_win_set_cursor(match.win, match.pos)
      -- vim.lsp.buf.go
      require('Comment.api').toggle.linewise.current()
    end)
    state:restore()
  end,
  search = {
    mode = function(str)
      return "\\<" .. str
    end
  }
})

--[[ local utils = require('telescope.utils')

local params = vim.lsp.util.make_position_params(0)
vim.lsp.buf_request(0, 'textDocument/documentSymbol', params, function(err, result, _, _)
  if err then
    vim.api.nvim_err_writeln(err.message)
  end
  -- vim.print(result)

  local symbols_sorter = function(symbols)
    if vim.tbl_isempty(symbols) then
      return symbols
    end

    local current_buf = vim.api.nvim_get_current_buf()

    -- sort adequately for workspace symbols
    local filename_to_bufnr = {}
    for _, symbol in ipairs(symbols) do
      if filename_to_bufnr[symbol.filename] == nil then
        filename_to_bufnr[symbol.filename] = vim.uri_to_bufnr(vim.uri_from_fname(symbol.filename))
      end
      symbol.bufnr = filename_to_bufnr[symbol.filename]
    end

    table.sort(symbols, function(a, b)
      if a.bufnr == b.bufnr then
        return a.lnum < b.lnum
      end
      if a.bufnr == current_buf then
        return true
      end
      if b.bufnr == current_buf then
        return false
      end
      return a.bufnr < b.bufnr
    end)

    return symbols
  end

  local locations = vim.lsp.util.symbols_to_items(result or {}, 0) or {}
  -- vim.print(locations)
  locations = utils.filter_symbols(locations, {}, symbols_sorter)
  -- vim.print(locations)
end) ]]
