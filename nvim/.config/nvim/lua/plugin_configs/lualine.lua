return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'kyazdani42/nvim-web-devicons', opt = true },
  config = function()
    -- Xcode project info for iOS development (xcodebuild.nvim)
    local function xcodebuild_info()
      local parts = {}
      if vim.g.xcodebuild_last_status then
        table.insert(parts, vim.g.xcodebuild_last_status)
      end
      if vim.g.xcodebuild_device_name then
        table.insert(parts, vim.g.xcodebuild_device_name)
      end
      return table.concat(parts, ' ')
    end

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'gruvbox-baby',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = { 'mode', {
          require("noice").api.statusline.mode.get,
          cond = require("noice").api.statusline.mode.has,
          color = { fg = "#ff9e64" },
        } },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 3 } },
        lualine_x = { 'encoding', 'fileformat', 'filetype', { xcodebuild_info, cond = function() return vim.g.xcodebuild_device_name ~= nil end } },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    }
  end
}
