local M = {}

function M.setup()
  local keeper = require('otter.keeper')
  local extract = keeper.extract_code_chunks
  local query = vim.treesitter.query.parse('phpjs', '(text) @javascript (php_tag) @tag')

  keeper.extract_code_chunks = function(bufnr, target_lang, ...)
    if vim.bo[bufnr].filetype ~= 'phpjs' or (target_lang and target_lang ~= 'javascript') then
      return extract(bufnr, target_lang, ...)
    end

    local source = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local lines = vim.tbl_map(function(line)
      return (line:gsub('%S', ' '))
    end, source)
    local root = keeper.rafts[bufnr].parser:parse(true)[1]:root()

    -- Keep one position-preserving chunk: Otter otherwise overwrites fragments
    -- sharing a line and skips regions ending just past the last buffer line.
    for id, node in query:iter_captures(root, bufnr) do
      local start_row, start_col, end_row, end_col = node:range()
      if query.captures[id] == 'javascript' then
        for row = start_row, math.min(end_row, #source - 1) do
          local first = row == start_row and start_col or 0
          local last = row == end_row and end_col or #source[row + 1]
          local index = row + 1
          lines[index] = lines[index]:sub(1, first)
            .. source[index]:sub(first + 1, last)
            .. lines[index]:sub(last + 1)
        end
      elseif vim.treesitter.get_node_text(node, bufnr) == '<?=' then
        -- An echoed PHP value needs a JS expression, not an empty argument or
        -- template interpolation. A single byte preserves all source columns.
        local index = start_row + 1
        lines[index] = lines[index]:sub(1, start_col) .. '0' .. lines[index]:sub(start_col + 2)
      end
    end

    return {
      javascript = { {
        lang = 'javascript',
        range = { from = { 0, 0 }, to = { #lines - 1, #lines[#lines] } },
        text = lines,
        leading_offset = 0,
      } },
    }
  end
end

return M
