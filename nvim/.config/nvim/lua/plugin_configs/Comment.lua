return {
  'numToStr/Comment.nvim',
  enabled = false,
  config = function()
    require('Comment').setup {
      -- add support for jsx comments
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    }
    local ft = require('Comment.ft')
    ft.set('blade', { '{{-- %s --}}', '{{-- %s --}}' })
  end
}
