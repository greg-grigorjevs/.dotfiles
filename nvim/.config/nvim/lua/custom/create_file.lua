local M = {}

local uv = vim.uv or vim.loop

local function is_absolute(path)
  return path:sub(1, 1) == '/' or path:match('^%a:[/\\]') ~= nil
end

local function normalize(path)
  return vim.fs.normalize(vim.fn.fnamemodify(path, ':p'))
end

local function notify_error(message)
  vim.notify(message, vim.log.levels.ERROR)
end

function M.prompt(base_dir, on_created)
  base_dir = normalize(base_dir or vim.fn.getcwd())

  vim.ui.input({
    prompt = ('Create relative to %s (end with / for a directory): ')
        :format(vim.fn.fnamemodify(base_dir, ':~:.')),
  }, function(input)
    if not input then return end

    input = vim.trim(input)
    if input == '' then return end

    local is_directory = input:match('[/\\]$') ~= nil
    local expanded = input
    if input:match('^[~$]') then
      expanded = vim.fn.expand(input)
    end

    local path = is_absolute(expanded) and expanded or vim.fs.joinpath(base_dir, expanded)
    path = vim.fs.normalize(path)

    if uv.fs_stat(path) then
      vim.notify('Path already exists: ' .. path, vim.log.levels.WARN)
      return
    end

    if is_directory then
      local result = vim.fn.mkdir(path, 'p')
      if result == 0 and vim.fn.isdirectory(path) ~= 1 then
        notify_error('Could not create directory: ' .. path)
        return
      end
    else
      local parent = vim.fs.dirname(path)
      local result = vim.fn.mkdir(parent, 'p')
      if result == 0 and vim.fn.isdirectory(parent) ~= 1 then
        notify_error('Could not create parent directory: ' .. parent)
        return
      end

      local fd, err = uv.fs_open(path, 'wx', 420)
      if not fd then
        notify_error(('Could not create file %s: %s'):format(path, err or 'unknown error'))
        return
      end
      uv.fs_close(fd)
    end

    vim.notify(('Created %s: %s'):format(is_directory and 'directory' or 'file', path))
    if on_created then on_created(path, is_directory) end
  end)
end

function M.from_picker(base_dir, close_picker)
  M.prompt(base_dir, function(path, is_directory)
    if is_directory then return end

    if close_picker then pcall(close_picker) end
    vim.schedule(function()
      local ok, err = pcall(vim.cmd, 'edit ' .. vim.fn.fnameescape(path))
      if not ok then
        notify_error(('Created %s, but could not open it: %s'):format(path, err))
      end
    end)
  end)
end

return M
