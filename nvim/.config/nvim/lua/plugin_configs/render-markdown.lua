local colors = require("gruvbox-baby.colors").config()
return {
  'MeanderingProgrammer/render-markdown.nvim',
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    render_modes = { 'n', 'v', 'V', 't', 'c', 'i' },
    anti_conceal = {
      enabled = true,
      ignore  = {
        head_icon = true,
        head_background = true,
        -- head_border = true,
        -- check_icon = true,
        -- check_scope = true
      }
    },
    heading = {
      sign = false,
      icons = { '# ', '## ', '### ', '#### ', '##### ' },
      backgrounds = { 'RenderMarkdownH2Bg' },
      width = 'block',
      foregrounds = { 'RenderMarkdownH2' },

    },
    code = {
      enabled = true,
      sign = false,
    },
    checkbox = {
      checked = {
        icon = '󰄲 ',
        -- scope_highlight = "RenderMarkdownChecked"
      }
    },
    indent = {
      enabled = true,
      skip_heading = false,
      render_modes = { 'n' },
      icon = ''
    }
  },
  enabled = true
}
