local M = {}

local uv = vim.uv or vim.loop

local function normalize(path)
  path = vim.fs.normalize(vim.fn.fnamemodify(path, ':p'))
  return uv.fs_realpath(path) or path
end

local function entry_path(entry)
  return entry.filename or vim.fn.bufname(entry.bufnr or -1)
end

local function in_directory(path, directory)
  -- Buffers without a file (terminals, help, ...) should not block a jump.
  if path == nil or path == '' then return true end

  path = normalize(path)
  return path == directory or path:sub(1, #directory + 1) == directory .. '/'
end

local function target_index(items, index, direction, count, directory)
  local found = 0
  local start = direction < 0 and index or index + 2

  while start >= 1 and start <= #items do
    if in_directory(entry_path(items[start]), directory) then
      found = found + 1
      if found == count then return start end
    end
    start = start + direction
  end
end

-- Jump through the window's jumplist, skipping entries outside the current
-- directory. direction is -1 for older jumps (<C-o>) and 1 for newer (<C-i>).
function M.jump(direction, count)
  local list = vim.fn.getjumplist()
  local items, index = list[1], list[2]
  local directory = normalize(vim.fn.getcwd())
  count = count and count > 0 and count or 1
  local target = target_index(items, index, direction, count, directory)

  if not target then
    vim.notify(
      ('No %s jump in %s'):format(direction < 0 and 'older' or 'newer', vim.fn.fnamemodify(directory, ':~')),
      vim.log.levels.INFO
    )
    return
  end

  local steps = direction < 0 and index - target + 1 or target - index - 1
  local key = direction < 0 and '<C-o>' or '<C-i>'
  vim.api.nvim_feedkeys(
    (steps > 1 and tostring(steps) or '') .. vim.api.nvim_replace_termcodes(key, true, false, true),
    'n',
    false
  )
end

return M
