local M = {}
local method = 'textDocument/definition'

function M.jump_to_definition()
  local target_win = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(target_win)
  local params = vim.lsp.util.make_position_params(target_win)

  vim.lsp.buf_request(bufnr, method, params, function(err, result, ctx, config)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then
      return
    end

    local handler = client.handlers[method] or vim.lsp.handlers[method]
    handler(err, result, ctx, vim.tbl_extend('force', config or {}, {
      on_list = function(options)
        -- Locations are sorted by file and position, so the class declaration
        -- comes before its constructor when both are returned.
        local item = options.items[1]
        if not item or not item.user_data or not vim.api.nvim_win_is_valid(target_win) then
          return
        end

        vim.api.nvim_win_call(target_win, function()
          vim.lsp.util.jump_to_location(item.user_data, client.offset_encoding)
        end)
      end,
    }))
  end)
end

return M
