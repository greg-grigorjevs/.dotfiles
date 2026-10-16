local M = {}

local function active_picker()
  local picker = require('fff.picker_ui.picker_ui')
  if not picker.state.active then return nil, nil end
  return picker, picker.state
end

local function absolute_path(relative_path)
  if not relative_path or relative_path == '' then return nil end

  local ok, path = pcall(require('fff.utils').canonicalize_fff_path, relative_path)
  return ok and path or nil
end

local function selected_paths(state)
  local paths = {}
  local seen = {}

  local function add(relative_path)
    local path = absolute_path(relative_path)
    if path and not seen[path] then
      seen[path] = true
      table.insert(paths, path)
    end
  end

  if state.mode == 'grep' then
    for _, item in pairs(state.selected_items or {}) do
      add(item.relative_path)
    end
  else
    local picker_state = require('fff.picker_ui.picker_ui_state')
    for _, entry in ipairs(picker_state.get_selected_file_entries()) do
      add(entry.relative_path)
    end
  end

  return paths
end

function M.add_to_harpoon()
  local picker, state = active_picker()
  if not picker then return end

  local paths = selected_paths(state)
  if #paths == 0 then
    local item = state.filtered_items[state.cursor]
    local path = item and absolute_path(item.relative_path)
    if not path then return end

    require('harpoon.mark').add_file(path)
    picker.select()
    return
  end

  for _, path in ipairs(paths) do
    require('harpoon.mark').add_file(path)
  end

  picker.close()
  vim.schedule(function() require('harpoon.ui').toggle_quick_menu() end)
end

function M.delete_file()
  local picker, state = active_picker()
  if not picker then return end

  local item = state.filtered_items[state.cursor]
  local path = item and absolute_path(item.relative_path)
  if not path then return end

  local confirm = vim.fn.input('Delete ' .. path .. '? (y/n): ')
  if confirm:lower() ~= 'y' then return end

  local success, err = os.remove(path)
  if not success then
    vim.notify('Error deleting ' .. path .. ': ' .. (err or 'unknown error'), vim.log.levels.ERROR)
    return
  end

  picker.close()
  require('fff').scan_files()
  vim.notify('Deleted: ' .. path, vim.log.levels.INFO)
end

function M.copy_path()
  local _, state = active_picker()
  if not state then return end

  local item = state.filtered_items[state.cursor]
  local path = item and absolute_path(item.relative_path)
  if not path then return end

  vim.fn.setreg('+', path)
  vim.notify('Copied path: ' .. path, vim.log.levels.INFO)
end

function M.create_file()
  local picker, state = active_picker()
  if not picker then return end

  local item = state.filtered_items[state.cursor]
  local path = item and absolute_path(item.relative_path)
  local base_dir
  if path then
    base_dir = vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path)
  else
    base_dir = require('fff.conf').get().base_path or vim.fn.getcwd()
  end

  require('custom.create_file').from_picker(base_dir, function()
    picker.close()
  end)
end

function M.yank_history()
  local ok, storage = pcall(require, 'neoclip.storage')
  if not ok then
    vim.notify('Neoclip is not available', vim.log.levels.ERROR)
    return
  end

  local history = storage.get().yanks or {}
  if #history == 0 then
    vim.notify('Yank history is empty', vim.log.levels.INFO)
    return
  end

  vim.ui.select(history, {
    prompt = 'Yank history (copy to *)',
    format_item = function(entry)
      local text = table.concat(entry.contents or {}, '\n'):gsub('%s+', ' ')
      if #text > 100 then text = text:sub(1, 97) .. '...' end
      return text
    end,
  }, function(entry)
    if entry then
      require('neoclip.handlers').set_registers({ '*' }, entry)
    end
  end)
end

return M
