return {
  'echasnovski/mini.comment',
  opts = {
    options = {
      custom_commentstring = function()
        local curline = vim.fn.line(".")
        local lang = vim.treesitter.get_parser():language_for_range({ curline, 0, curline, 0 }):lang()
        -- vim.print(lang)
        if vim.bo.filetype == 'blade' then
          curline = vim.fn.line(".")
          lang = vim.treesitter.get_parser():language_for_range({ curline, 0, curline, 0 }):lang()
          -- vim.print(lang)
          if lang == 'php' or lang == 'php_only' or lang == 'javascript' then
            return '// %s'
          end
          return '{{-- %s --}}'
        elseif vim.bo.filetype == 'php' then
          return '// %s'
        else
          return nil
        end
      end
    },
    mappings = {
      -- Toggle comment (like `gcip` - comment inner paragraph) for both
      -- Normal and Visual modes
      comment = 'g/',

      -- Toggle comment on current line
      comment_line = 'g//',

      -- Toggle comment on visual selection
      comment_visual = 'g/',

      -- Define 'comment' textobject (like `dgc` - delete whole comment block)
      -- Works also in Visual mode if mapping differs from `comment_visual`
      textobject = 'g/',
    }
  }
}
