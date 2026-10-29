return {
  'echasnovski/mini.snippets',
  event = 'InsertEnter',
  version = '*',
  config = function()
    local gen_loader = require('mini.snippets').gen_loader
    require('mini.snippets').setup({
      snippets = {
        gen_loader.from_lang()
      },
      mappings = {
        expand = '<C-l>'
      }

    })
  end
}
