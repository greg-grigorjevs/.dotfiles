local pickers = require('telescope.pickers')

local actions = require('telescope.actions')
local state = require('telescope.actions.state')
local utils = require('telescope.actions.utils')

local M = {}

M.delete_file = function(bufnr)
  --- @type Picker
  local picker = state.get_current_picker(bufnr)

  picker:delete_selection(function(selection)
    local file_path = selection.path or selection[1] -- Handle different picker formats
    local confirm = vim.fn.input("Delete " .. file_path .. "? (y/n): ")
    if confirm:lower() ~= "y" then
      return
    end

    -- Delete the file
    local success, err = os.remove(file_path)
    if not success then
      print("Error deleting " .. file_path .. ": " .. (err or "unknown error"))
      return
    end
    print("Deleted: " .. file_path)

    -- move the cursor at the end of the prompt
    -- vim.fn.input doesn't do that automatically
    local key = vim.api.nvim_replace_termcodes("<End>", true, false, true)
    vim.api.nvim_feedkeys(key, 'n', false)
  end)
end

return M
--
-- require('telescope.builtin').find_files {
--   attach_mappings = function(_, map)
--     map('i', '<C-l>', find_with_delete)
--     return true
--   end,
--   prompt = 'test'
-- }
