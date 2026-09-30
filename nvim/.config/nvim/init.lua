if vim.loader then
  vim.loader.enable()
end

require('autocommands')
require('plugins')
require('settings')
require('mappings')

vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  callback = function()
    require('lsp')
  end,
})


--[[
notes for feature for fresh installations

01. make sure ripgrep is installed for telescope grep search
--]]
